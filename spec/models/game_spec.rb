require 'rails_helper'

RSpec.describe Game, type: :model do
  
  describe "#populate_board!" do
    it 'places the correct number of pawns on the board' do
      
      # white_user = FactoryGirl.create(:user)
      # black_user = FactoryGirl.create(:user)

      game = FactoryGirl.create(:game, white_player_id: :white_player, black_player_id: :black_player)
      
      # game.update(white_player_id: white_user.id, black_player_id: black_user.id)
      # game = Game.create(id: 1, white_player: 1, black_player: 2)
      
      game.populate_board!

      expect(game.pawns.white.count).to eq 8
      # expect(game.white_player.row_coordinate).to eq(1)
      # expect(game.white_player.column_coordinate).to eq(0..7)
      # expect(game.black_player.pawns.count).to eq 8
      # expect(game.black_player.pawns.row_coordinate).to eq(6)
      # expect(game.black_player.pawns.column_coordinate).to eq(0..7)
    end

    it 'places the correct number of rooks on the board' do
      game = FactoryGirl.create(:game)

      
      game.populate_board!

      expect(game.rooks.white.count).to eq 2
      
      expect(game.rooks.black.count).to eq 2
      
    end

    it 'places the correct number of knights on the board' do
      
      game = FactoryGirl.create(:game)

      game.populate_board!

      expect(game.knights.white.count).to eq 2
      expect(game.knight.black.count).to eq 2
    end

    it 'places the correct number of bishopss on the board' do
      
      game = FactoryGirl.create(:game)

      game.populate_board!

      expect(game.bishops.white.count).to eq 2
      expect(game.bishops.black.count).to eq 2
    end

    it 'places the correct number of kings on the board' do
      
      game = FactoryGirl.create(:game)

      game.populate_board!

      expect(game.kings.white.count).to eq 1
      expect(game.kings.black.count).to eq 1
    end

    it 'places the correct number of queens on the board' do
      
      game = FactoryGirl.create(:game)

      game.populate_board!

      expect(game.queens.white.count).to eq 1
      expect(game.queens.black.count).to eq 1
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


