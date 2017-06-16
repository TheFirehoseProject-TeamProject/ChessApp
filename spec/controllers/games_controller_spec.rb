
require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }

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
end
