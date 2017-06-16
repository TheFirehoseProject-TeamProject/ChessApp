require 'rails_helper'

RSpec.describe Rook, type: :model do
  let(:game) { FactoryGirl.create(:game) }
  let(:user) { FactoryGirl.create(:user) }
  let(:rook) { FactoryGirl.create(:rook, :is_on_board) }

  describe 'is rook.valid_move?' do
    expect(rook.valid_move?(4, 6)). to eq true
    expect(rook.valid_move?(6, 5)). to eq false
    expect(rook.valid_move?(7, 7)). to eq false
    expect(rook.valid_move?(6, 2)). to eq false
    expect(rook.valid_move?(8, 4)). to eq true
  end
end
