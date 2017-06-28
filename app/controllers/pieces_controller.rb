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
      redirect_to game_path(@piece.game_id)
    else
      render plain: 'Invalid Move', status: :bad_request
    end
  end

  def flash_game_status
    @piece.game.update(turn: -1) if @piece.game.checkmate?
    @piece.game.update(turn: -2) if @piece.game.stalemate?
    flash[:notice] = 'Checkmate !!' if @piece.game.turn == -1
    flash[:notice] = 'Stalemate !!' if @piece.game.turn == -2
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
