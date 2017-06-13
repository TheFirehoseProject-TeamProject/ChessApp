require 'rails_helper'

RSpec.describe Bishop, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:bishop ) { FactoryGirl.create(:bishop, :is_on_board) }
  describe "movement of bishop" do
    it "should only move diagonally" do
      expect(bishop.valid_move?(2,2)).to eq true
      expect(bishop.valid_move?(4,2)).to eq true
      expect(bishop.valid_move?(2,4)).to eq true
      expect(bishop.valid_move?(4,4)).to eq true
      expect(bishop.valid_move?(0,0)).to eq true
      expect(bishop.valid_move?(6,0)).to eq true
      expect(bishop.valid_move?(0,6)).to eq true
      expect(bishop.valid_move?(6,6)).to eq true
    end
  end
end
