require 'rails_helper'

RSpec.describe Game, type: :model do
  
  describe "#populate_board!" do

    it 'places the correct number of pawns on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
       # game = FactoryGirl.create(:game, params: { white_player: white_player, black_player: black_player })
      game.populate_board!

      expect(game.pieces.where(type: 'Pawn', color: 'white').count).to eq 8
      expect(game.pieces.where(type: 'Pawn', color: 'black').count).to eq 8
      # expect(game.white_player.row_coordinate).to eq(1)
      # expect(game.white_player.column_coordinate).to eq(0..7)
      # expect(game.black_player.pawns.count).to eq 8
      # expect(game.black_player.pawns.row_coordinate).to eq(6)
      # expect(game.black_player.pawns.column_coordinate).to eq(0..7)
    end

    it 'places the correct number of rooks on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
      game.populate_board!

      expect(game.pieces.where(type: 'Rook', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Rook', color: 'black').count).to eq 2
      
    end

    it 'places the correct number of knights on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
      game.populate_board!

      expect(game.pieces.where(type: 'Knight', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Knight', color: 'black').count).to eq 2
    end

    it 'places the correct number of bishops on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
      game.populate_board!

      expect(game.pieces.where(type: 'Bishop', color: 'white').count).to eq 2
      expect(game.pieces.where(type: 'Bishop', color: 'black').count).to eq 2
    end

    it 'places the correct number of kings on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
      game.populate_board!

      expect(game.pieces.where(type: 'King', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'King', color: 'black').count).to eq 1
    end

    it 'places the correct number of queens on the board' do
      white_player = FactoryGirl.create(:user)
      black_player = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player: white_player, black_player: black_player )
      game.populate_board!
      
      expect(game.pieces.where(type: 'Queen', color: 'white').count).to eq 1
      expect(game.pieces.where(type: 'Queen', color: 'black').count).to eq 1
    end
  end
    

end

# expect(king.row_coordinate).to eq(0)
#       expect(king.column_coordinate).to eq(4)
#       expect(queen.row_coordinate).to eq(0)
#       expect(queen.column_coordinate).to eq(3)
#       expect(bishop1.row_coordinate).to eq(0)
#       expect(bishop1.column_coordinate).to eq(2)
#       expect(bishop2.row_coordinate).to eq(0)
#       expect(bishop2.column_coordinate).to eq(5)
#       expect(rook1.row_coordinate).to eq(0)
#       expect(rook1.column_coordinate).to eq(0)
#       expect(rook2.row_coordinate).to eq(0)
#       expect(rook2.column_coordinate).to eq(7)
#       expect(knight1.row_coordinate).to eq(0)
#       expect(knight1.column_coordinate).to eq(1)
#       expect(knight2.row_coordinate).to eq(0)
#       expect(knight2.column_coordinate).to eq(6)
#       expect(game.pawns.row_coordinate).to eq(0)

#       expect(white_king.row_coordinate).to eq(7)
#       expect(white_king.column_coordinate).to eq(4)
#       expect(white_queen.row_coordinate).to eq(7)
#       expect(white_queen.column_coordinate).to eq(3)
#       expect(white_bishop1.row_coordinate).to eq(7)
#       expect(white_bishop1.column_coordinate).to eq(2)
#       expect(white_bishop2.row_coordinate).to eq(7)
#       expect(white_bishop2.column_coordinate).to eq(5)
#       expect(white_rook1.row_coordinate).to eq(7)
#       expect(white_rook1.column_coordinate).to eq(0)
#       expect(white_rook2.row_coordinate).to eq(7)
#       expect(white_rook2.column_coordinate).to eq(7)
#       expect(white_knight1.row_coordinate).to eq(7)
#       expect(white_knight1.column_coordinate).to eq(1)
#       expect(white_knight2.row_coordinate).to eq(7)
#       expect(white_knight2.column_coordinate).to eq(6)
#       expect(game.pawns.row_coordinate).to eq(7)


