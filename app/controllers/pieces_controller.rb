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
    current_piece_type = @piece.type
    render plain: 'Invalid Move', status: :bad_request if @piece.not_moved?(destination_x, destination_y)
    if !@piece.obstructed?(destination_x, destination_y) && @piece.valid_move?(destination_x, destination_y) && check_turn == @piece.color
      change_turn

      if @piece.pawn_promotion?(destination_y)
        # pawn_promotion_choice = piece_params[:pawn_promotion]

        # pawn_promotion_choice = piece_params[:type]
        # @piece.type = pawn_promotion_choice
        # @piece.image = @piece.color.capitalize + pawn_promotion_choice + '.png'
      end

      @piece.move_to!(destination_x, destination_y)
      current_game.set_game_status



      # if (@piece.destination_y.zero? && current_piece_type == 'Pawn') || (@piece.destination_y == 7 && current_piece_type == 'Pawn')
      #   Pusher.trigger('piece_moved_game' + @piece.game.id.to_s, 'piece_moved', message: flashmessages,
      #                                                                              turn: check_turn,
      #                                                                              row_destination: destination_y,
      #                                                                              column_destination: destination_x,
      #                                                                              row_origin: current_row,
      #                                                                              column_origin: current_column,
      #                                                                              type: current_piece_type)
      # pawn_promotion
      # else
      Pusher.trigger('piece_moved_game' + @piece.game.id.to_s, 'piece_moved', message: flashmessages,
                                                                              turn: check_turn,
                                                                              row_destination: destination_y,
                                                                              column_destination: destination_x,
                                                                              row_origin: current_row,
                                                                              column_origin: current_column,
                                                                              type: current_piece_type)
      # end
    else
      render plain: 'Invalid Move', status: :bad_request
    end
  end

  # def pawn_promotion
  #   respond_to do |format|
  #     format.gameShow.js { render :js => 'app/assets/javascripts/gameShow.js' }
  #   end
  # end

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
