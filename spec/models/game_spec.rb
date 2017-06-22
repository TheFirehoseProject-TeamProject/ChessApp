require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#check?' do
    it 'returns true if king is in check' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)

      king = FactoryGirl.create(:king, game: game)
      queen = FactoryGirl.create(:queen, row_coordinate: 3, game: game)

      expect(game.check?).to eq(true)
    end

    it 'returns false if king is not in check' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)

      king = FactoryGirl.create(:king, game: game)
      queen = FactoryGirl.create(:queen, row_coordinate: 2, column_coordinate: 3, game: game)

      expect(game.check?).to eq(false)
    end
  end

  describe '#populate_board!' do
    it 'places the correct number of pawns on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)

      game.populate_board!

      expect(game.pieces.where(type: 'Pawn', color: 'white').count).to eq 8
      expect(game.pieces.where(type: 'Pawn', color: 'black').count).to eq 8
    end

    it 'places the correct number of rooks on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)
      game.populate_board!

      expect(game.pieces.where(type: 'Rook', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Rook', color: 'black').count).to eq 2
    end

    it 'places the correct number of knights on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)
      game.populate_board!

      expect(game.pieces.where(type: 'Knight', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Knight', color: 'black').count).to eq 2
    end

    it 'places the correct number of bishops on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)
      game.populate_board!

      expect(game.pieces.where(type: 'Bishop', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Bishop', color: 'black').count).to eq 2
    end

    it 'places the correct number of kings on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)
      game.populate_board!

      expect(game.pieces.where(type: 'King', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'King', color: 'black').count).to eq 1
    end

    it 'places the correct number of queens on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player)
      game.populate_board!

      expect(game.pieces.where(type: 'Queen', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'Queen', color: 'black').count).to eq 1
    end
  end
end
