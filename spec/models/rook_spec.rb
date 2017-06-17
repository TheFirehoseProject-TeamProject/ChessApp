require 'rails_helper'

RSpec.describe Rook, type: :model do
  describe "is valid move? will return false if it is not allowed" do
  before :each do
    game = FactoryGirl.create(:join_game)
    rook = Rook.create(destination_x: 4, destination_y: 4)
  end

    it "returns false if moving 2 spaces up" do
      expect(rook.valid_move?(4,6)).to eq true
    end
    it "returns false if moves like a knight" do
      expect(rook.valid_move?(6,5)).to eq false
    end
    it "returns true if moves diagonal 3 spaces" do
      expect(rook.valid_move?(7,7)).to eq false
    end 
    it "returns true if moves diagonal 2 spaces" do
      expect(rook.valid_move?(6,2)).to eq false
    end 
    it "returns false if it tries to move horizontally" do
      expect(rook.valid_move?(8,4)).to eq true
    end
  end
end