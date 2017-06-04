
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'games#show action' do
    it 'should show an empty chessboard' do
      get :show, params: { id: 1 }
      expect(response).to have_http_status(:success)
    end
  end
end
