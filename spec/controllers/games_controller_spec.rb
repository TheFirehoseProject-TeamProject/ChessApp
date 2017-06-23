
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user, game_id: game) }

  describe 'games#show action' do
    it 'should ask the user to be signed in' do
      get :show, params: { id: game.id }
      expect(response).to redirect_to new_user_session_path
    end
    it 'should show an empty board if user is signed_in and waiting for another user' do
      sign_in user
      get :show, params: { id: game.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'games#create action' do
    it 'should set turn to white player' do
      sign_in user
      post :create, params: { game: { white_player_id: user.id } }
      expect(Game.last.turn).to eq(user.id)
    end
    it 'should change turns after a move' do
      black_player = FactoryGirl.create(:user, game_id: game)
      sign_in user
      sign_in black_player
      game.update_attributes(white_player_id: user.id, black_player_id: black_player.id, turn: user.id)
      game.populate_board!
      pawn = game.pieces.find_by(type: 'Pawn', column_coordinate: 0, row_coordinate: 1)
      post :update, params: { piece: { row_coordinate: 2, column_coordinate: 0, color: 'white', type: 'Pawn', game_id: game } }
      game.reload
      expect(game.turn).to eq(black_player.id)
    end
  end
end
