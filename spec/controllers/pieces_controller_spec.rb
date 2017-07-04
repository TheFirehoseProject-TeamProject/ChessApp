require 'rails_helper'

RSpec.describe PiecesController, type: :controller do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game_id: game) }

  describe 'piece#update action' do
    it 'should change turns after a piece moves' do
      black_player = FactoryGirl.create(:user, game_id: game)
      sign_in user
      sign_in black_player
      game.update_attributes(white_player: user, black_player: black_player, turn: user.id)
      game.populate_board!
      pawn = game.pieces.find_by(type: 'Pawn', column_coordinate: 0, row_coordinate: 1)
      patch :update, params: { id: pawn.id, piece: { row_coordinate: 2, column_coordinate: 0 } }
      game.reload
      expect(game.turn).to eq(black_player.id)
    end
  end

  describe 'piece#pawn_promote' do
    let(:game_pp) { FactoryGirl.create(:game) }
    let(:black_player) { FactoryGirl.create(:user, game_id: game_pp) }
    let(:white_player) { FactoryGirl.create(:user, game_id: game_pp) }
    let(:pawn_w) { FactoryGirl.create(:pawn, game_id: game_pp, color: 'white', is_on_board?: true, column_coordinate: 1, row_coordinate: 6 ) }
    before(:all) do
      sign_in white_player
      sign_in black_player
    end

    it 'changes pawn to a queen if queen is selected' do
      
      expect{ pawn_w.move_to!(1, 7) }.to change{ pawn_w.type }
    end
    it 'changes pawn to a rook if rook is selected' do
    end
    it 'changes pawn to a bishop if bishop is selected' do
    end
    it 'changes pawn to a knight if knight is selected' do
    end
  end
end
