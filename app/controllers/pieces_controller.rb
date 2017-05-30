class PiecesController < ApplicationController
  def create
    @piece = pieces.create()
  end
end
