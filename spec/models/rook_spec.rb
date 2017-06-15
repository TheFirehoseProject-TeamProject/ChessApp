require 'rails_helper'

RSpec.describe Rook, type: :model do 
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:rook) { FactoryGirl.create(:rook, :is_on_board) }

  describe 'moves for rook' do
    it 'should be valid when moving up one space' do
      expect(rook.valid_move?(1,1)).to eq true
    end
    it 'should be valid when moving right two spaces right' do 
      expect(rook.valid_move?(3,0)). to eq true
    end
    it 'should be valid when moving right three spaces left' do
      expect(rook.valid_move?(1,3)). to eq true
    end
    it 'should be valid when moving four spaces down' do
      expect(rook.valid_move?(4,0)). to eq true
    end
    it 'should be invalid when moving one space diagonally' do
      expect(rook.valid_move?(2,1)). to eq false
    end
    it 'should be invalid when moving tree spaces diagonally' do
      expect(rook.valid_move?(4,3)). to eq false
    end
    it 'should be invalid when a piece is obstructed' do
      expect(rook.valid_move?(6,4)). to eq false
    end
    it 'should be invalid when the piece moves off the board' do
      expect(rook.valid_move?(-1,4)). to eq false
    end
  end
