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
    if !@piece.obstructed?(destination_x, destination_y) && @piece.valid_move?(destination_x, destination_y)
      @piece.move_to!(destination_x, destination_y)
      checks_turn_and_color
      redirect_to game_path(@piece.game_id)
    else
      render plain: 'Invalid Move', status: :bad_request
    end
  end

  def checks_turn_and_color
    if current_game.turn == current_game.white_player.id && @piece.color == 'white'
      current_game.update_attributes(turn: current_game.black_player_id)
    elsif current_game.turn == current_game.black_player.id && @piece.color == 'black'
      current_game.update_attributes(turn: current_game.white_player_id)
    end
  end
end
