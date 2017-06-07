
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:game) { FactoryGirl.create(:game) }

  subject

  describe 'games#show action' do
    it 'should show an empty chessboard' do
      get :show, params: { id: current_game.id }
      expect(response).to have_http_status(:success)
    end
  end
end
