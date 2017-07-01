require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.describe Game, type: :model do
  let(:white_player) { FactoryGirl.create(:user) }
  let(:black_player) { FactoryGirl.create(:user) }
  let(:game) { FactoryGirl.create(:game, white_player: white_player, black_player: black_player, turn: white_player.id) }

  describe '#checkmate?' do
    it 'returns true if king is in checkmate' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 6, column_coordinate: 1, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 7, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:bishop, :is_on_board, row_coordinate: 0, column_coordinate: 6, user: white_player, color: 'white', game: game)
      expect(game.checkmate?).to eq(true)
    end
    it 'should return false if the king can move out of the check' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 5, column_coordinate: 2, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 7, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:bishop, :is_on_board, row_coordinate: 0, column_coordinate: 0, user: white_player, color: 'white', game: game)
      expect(game.checkmate?).to eq(false)
    end
    it 'should return false if king can capture attacker' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 0, column_coordinate: 6, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 7, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:bishop, :is_on_board, row_coordinate: 0, column_coordinate: 0, user: white_player, color: 'white', game: game)
      expect(game.checkmate?).to eq(false)
    end
    it 'should return false if another piece can capture attacker' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 0, column_coordinate: 4, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 0, column_coordinate: 5, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 7, user: black_player, color: 'black', game: game)
      expect(game.checkmate?).to eq(false)
    end
    it 'should return false if another piece can move inbetween attacker' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 2, column_coordinate: 7, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 1, column_coordinate: 5, user: white_player, color: 'black', game: game)
      FactoryGirl.create(:bishop, :is_on_board, row_coordinate: 3, column_coordinate: 5, user: white_player, color: 'white', game: game)
      expect(game.checkmate?).to eq(false)
    end
    it 'checkmate does not remove existing pieces' do
      game.populate_board!
      pawn = game.pieces.find_by(type: 'Pawn', color: 'black', row_coordinate: 6, column_coordinate: 5)
      queen = game.pieces.find_by(type: 'Queen', color: 'white')
      pawn.update(row_coordinate: -1, column_coordinate: -1, is_on_board?: false)
      queen.update(row_coordinate: 6, column_coordinate: 5)
      game.update(turn: black_player.id)
      expect(game.check?).to eq(true)
      expect(game.checkmate?).to eq(false)
      expect(game.pieces.where(is_on_board?: false).count).to eq(1)
    end
  end

  describe '#stalemate' do
    it 'returns true if in stalemate for white' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 1, column_coordinate: 5, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 6, user: white_player, color: 'black', game: game)
      FactoryGirl.create(:pawn, :is_on_board, row_coordinate: 1, column_coordinate: 6, user: white_player, color: 'white', game: game)

      expect(game.stalemate?).to eq(true)
    end
    it 'returns true if in stalemate for black' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 2, column_coordinate: 6, user: black_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 6, user: white_player, color: 'white', game: game)
      game.update(turn: black_player.id)
      expect(game.stalemate?).to eq(true)
    end
    it 'returns false if a black piece can still move' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 2, column_coordinate: 6, user: black_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 0, column_coordinate: 7, user: white_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 6, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:pawn, :is_on_board, row_coordinate: 1, column_coordinate: 0, user: white_player, color: 'black', game: game)
      game.update(turn: black_player.id)
      expect(game.stalemate?).to eq(false)
    end
  end

  describe '#check?' do
    it 'returns true if king is in check' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 3, column_coordinate: 4, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 4, column_coordinate: 4, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 2, user: white_player, color: 'black', game: game)

      expect(game.check?).to eq(true)
    end

    it 'returns false if king is not in check' do
      FactoryGirl.create(:queen, :is_on_board, row_coordinate: 2, column_coordinate: 3, user: black_player, color: 'black', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 4, column_coordinate: 4, user: white_player, color: 'white', game: game)
      FactoryGirl.create(:king, :is_on_board, row_coordinate: 2, column_coordinate: 2, user: white_player, color: 'black', game: game)

      expect(game.check?).to eq(false)
    end
  end

  describe '#populate_board!' do
    it 'places the correct number of pawns on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'Pawn', color: 'white').count).to eq 8
      expect(game.pieces.where(type: 'Pawn', color: 'black').count).to eq 8
    end

    it 'places the correct number of rooks on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'Rook', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Rook', color: 'black').count).to eq 2
    end

    it 'places the correct number of knights on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'Knight', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Knight', color: 'black').count).to eq 2
    end

    it 'places the correct number of bishops on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'Bishop', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Bishop', color: 'black').count).to eq 2
    end

    it 'places the correct number of kings on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'King', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'King', color: 'black').count).to eq 1
    end

    it 'places the correct number of queens on the board' do
      game.populate_board!

      expect(game.pieces.where(type: 'Queen', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'Queen', color: 'black').count).to eq 1
    end
  end
end
