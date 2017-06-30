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
    destination_x = piece_params[:column_coordinate].to_i
    destination_y = piece_params[:row_coordinate].to_i
    render plain: 'Invalid Move', status: :bad_request if @piece.not_moved?(destination_x, destination_y)
    if !@piece.obstructed?(destination_x, destination_y) && @piece.valid_move?(destination_x, destination_y) && check_turn == @piece.color
      change_turn
      @piece.move_to!(destination_x, destination_y)
      current_game.set_game_status
      flashmessages
      redirect_to game_path(@piece.game_id)
    else
      render plain: 'Invalid Move', status: :bad_request
    end
  end

  def flashmessages
    return flash[:notice] = 'Checkmate !!' if current_game.game_status == 1
    return flash[:notice] = 'Stalemate !!' if current_game.game_status == 2
    return flash[:notice] = 'Check !!' if current_game.game_status == 3
    return flash[:notice] = 'Draw !!' if current_game.game_status == 4
    false
  end

  def check_turn
    return 'white' if current_game.turn == current_game.white_player.id && @piece.color == 'white'
    return 'black' if current_game.turn == current_game.black_player.id && @piece.color == 'black'
    false
  end

  def change_turn
    current_game.update(turn: current_game.black_player_id) if check_turn == 'white'
    current_game.update(turn: current_game.white_player_id) if check_turn == 'black'
  end
end
