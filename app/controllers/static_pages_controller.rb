# Just a controller to set up an initial root page to test Heroku deployment
class StaticPagesController < ApplicationController
  def index
    @available_games = Game.available
  end
end
