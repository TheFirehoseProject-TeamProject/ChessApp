require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { FactoryGirl.create(:game) }

  describe "#populate_board!" do
    it 'places the correct number of pawns on the board' do
      game.populate_board!

      expect(game.pawns.white.count).to eq 8
      expect(game.pawns.black.count).to eq 8
    end
  end
    
end


