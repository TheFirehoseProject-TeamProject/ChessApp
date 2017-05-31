require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "games#create" do
    it "should populate the board" do
      game = Game.create
      post :create, params: {name: 'new_game'}

      game.populate_board!

      (0..7).each do |i|
        Pawn.create(
          row_coordinate: 6,
          column_coordinate: i,
          color: "white",
          )
      end

    white_rook1 = Rook.create(
      row_coordinate: 7,
      column_coordinate: 0,
      color: "white"
      )

    white_rook2 = Rook.create(
      row_coordinate: 7,
      column_coordinate: 7,
      color: "white"
      )

    white_knight1 = Knight.create(
      row_coordinate: 7,
      column_coordinate: 1,
      color: "white"
      )

    white_knight2 = Knight.create(
      row_coordinate: 7,
      column_coordinate: 6,
      color: "white"
      )

    white_bishop1 = Bishop.create(
      row_coordinate: 7,
      column_coordinate: 2,
      color: "white"
      )

    white_bishop2 = Bishop.create(
      row_coordinate: 7,
      column_coordinate: 5,
      color: "white"
      )

    white_queen = Queen.create(
      row_coordinate: 7,
      column_coordinate: 3,
      color: "white"
      )

    white_king = King.create(
      row_coordinate: 7,
      column_coordinate: 4,
      color: "white"
      )

    # Build black pieces
    (0..7).each do |i|
      Pawn.create(
        row_coordinate: 1,
        column_coordinate: i,
        color: "black"
        )
    end

      rook1 = Rook.create(
        row_coordinate: 0,
        column_coordinate: 0,
        color: "black"
        )

      rook2 = Rook.create(
        row_coordinate: 0,
        column_coordinate: 7,
        color: "black"
        )

      knight1 = Knight.create(
        row_coordinate: 0,
        column_coordinate: 1,
        color: "black"
        )

      knight2 = Knight.create(
        row_coordinate: 0,
        column_coordinate: 6,
        color: "black"
        )

      bishop1 = Bishop.create(
        row_coordinate: 0,
        column_coordinate: 2,
        color: "black"
        )

      bishop2 = Bishop.create(
        row_coordinate: 0,
        column_coordinate: 5,
        color: "black"
        )

      queen = Queen.create(
        row_coordinate: 0,
        column_coordinate: 3,
        color: "black"
        )

      king = King.create(
        row_coordinate: 0,
        column_coordinate: 4,
        color: "black"
        )

      expect(king.row_coordinate).to eq(0)
      expect(king.column_coordinate).to eq(4)
      expect(queen.row_coordinate).to eq(0)
      expect(queen.column_coordinate).to eq(3)
      expect(bishop1.row_coordinate).to eq(0)
      expect(bishop1.column_coordinate).to eq(2)
      expect(bishop2.row_coordinate).to eq(0)
      expect(bishop2.column_coordinate).to eq(5)
      expect(rook1.row_coordinate).to eq(0)
      expect(rook1.column_coordinate).to eq(0)
      expect(rook2.row_coordinate).to eq(0)
      expect(rook2.column_coordinate).to eq(7)
      expect(knight1.row_coordinate).to eq(0)
      expect(knight1.column_coordinate).to eq(1)
      expect(knight2.row_coordinate).to eq(0)
      expect(knight2.column_coordinate).to eq(6)
      expect(game.pawns.row_coordinate).to eq(0)

      expect(white_king.row_coordinate).to eq(7)
      expect(white_king.column_coordinate).to eq(4)
      expect(white_queen.row_coordinate).to eq(7)
      expect(white_queen.column_coordinate).to eq(3)
      expect(white_bishop1.row_coordinate).to eq(7)
      expect(white_bishop1.column_coordinate).to eq(2)
      expect(white_bishop2.row_coordinate).to eq(7)
      expect(white_bishop2.column_coordinate).to eq(5)
      expect(white_rook1.row_coordinate).to eq(7)
      expect(white_rook1.column_coordinate).to eq(0)
      expect(white_rook2.row_coordinate).to eq(7)
      expect(white_rook2.column_coordinate).to eq(7)
      expect(white_knight1.row_coordinate).to eq(7)
      expect(white_knight1.column_coordinate).to eq(1)
      expect(white_knight2.row_coordinate).to eq(7)
      expect(white_knight2.column_coordinate).to eq(6)
      expect(game.pawns.row_coordinate).to eq(7)
    end
  end
end