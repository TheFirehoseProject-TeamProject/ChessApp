# Just a controller to set up an initial root page to test Heroku deployment
class StaticPagesController < ApplicationController
  def index 
    @games = Game.all
  end
end
