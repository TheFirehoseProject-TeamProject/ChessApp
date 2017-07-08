class DashboardController < ApplicationController
  before_action :authenticate_user!, only: %i[show]

  def show
    @current_matches = current_matches
    @open_matches = open_matches
  end

  def current_matches
    if player_signed_in?
      @current_matches = Game.where('black_player_id = ? or white_player_id = ?', current_user.id, current_user.id).order('updated_at').to_a.first(10)
     end
  end

  def open_matches
    if player_signed_in?
      @open_matches = Game.where(white_player_id: nil).where.not(black_player_id: current_user.id).first(10)
    end
  end
end
