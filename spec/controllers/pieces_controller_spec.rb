require 'rails_helper'
require 'spec_helper'

RSpec.describe PiecesController, type: :controller do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game_id: game) }
  describe 'piece#update action' do
    it 'should change turns after a piece moves' do
      black_player = FactoryGirl.create(:user, game_id: game)
      sign_in black_player
      sign_in user
      game.update_attributes(white_player: user, black_player: black_player, turn: user.id)
      game.populate_board!
      pawn = game.pieces.find_by(type: 'Pawn', column_coordinate: 0, row_coordinate: 1)
      patch :update, params: { id: pawn.id, piece: { row_coordinate: 2, column_coordinate: 0 } }
      game.reload
      expect(game.turn).to eq(black_player.id)
    end
  end
end
