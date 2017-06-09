class PiecesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :update
  def show
    @piece = Piece.find(params[:id])
    @board = current_board
  end

  def update
    @piece = Piece.find(params[:id])
    @piece.update(piece_params)
    redirect_to game_path(@piece.game_id)
  end

  private

  def current_game
    @current_game ||= Game.find(@piece.game_id)
  end

  def piece_params
    params.require(:piece).permit(:row_coordinate, :column_coordinate, :type, :color)
  end
end
