class PiecesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update
  def update
    @piece = Piece.find(params[:id])
    checks_before_move
  end

  private

  def current_game
    @current_game ||= Game.find(@piece.game_id)
  end

  def piece_params
    params.require(:piece).permit(:row_coordinate, :column_coordinate, :type, :color, :id)
  end

  def checks_before_move
    flashmessages
    destination_x = piece_params[:column_coordinate].to_i
    destination_y = piece_params[:row_coordinate].to_i
    current_row = @piece.row_coordinate
    current_column = @piece.column_coordinate
    en_passant_flag = @piece.game.piece_capturable_by_en_passant
    destination_piece = @piece.find_destination_piece(destination_x, destination_y).present?
    render plain: 'Invalid Move', status: :bad_request if @piece.not_moved?(destination_x, destination_y)
    if !@piece.obstructed?(destination_x, destination_y) && @piece.valid_move?(destination_x, destination_y) && check_turn == @piece.color
      @piece.move_to!(destination_x, destination_y)
      change_turn
      current_game.set_game_status
      Pusher.trigger('piece_moved_game' + @piece.game.id.to_s, 'piece_moved', message: flashmessages,
                                                                              turn: check_turn,
                                                                              type: @piece.type,
                                                                              color: @piece.color,
                                                                              destination_piece: destination_piece,
                                                                              en_passant_id: en_passant_flag,
                                                                              row_destination: destination_y,
                                                                              column_destination: destination_x,
                                                                              row_origin: current_row,
                                                                              column_origin: current_column)
    else
      render plain: 'Invalid Move', status: :bad_request
    end
  end

  def flashmessages
    return 'Checkmate !!' if current_game.game_status == 1
    return 'Stalemate !!' if current_game.game_status == 2
    return 'Check !!' if current_game.game_status == 3
    return 'Draw !!' if current_game.game_status == 4
    false
  end

  def check_turn
    return false unless @piece.user_id == current_user.id || @piece.game.playing_against_yourself?
    return 'white' if @piece.game.turn == current_game.white_player.id && @piece.color == 'white'
    return 'black' if @piece.game.turn == current_game.black_player.id && @piece.color == 'black'
    false
  end

  def change_turn
    current_game.update(turn: current_game.black_player_id) if check_turn == 'white'
    current_game.update(turn: current_game.white_player_id) if check_turn == 'black'
  end
end
