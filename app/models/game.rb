class Game < ApplicationRecord
  has_many :users
  has_many :pieces

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }

  def populate_board!
    # this should create all 32 pieces with their initial X/Y coordinates.
    
    # Build white pieces

    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        row_coordinate: 6,
        column_coordinate: i,
        color: "white",
        )
    end

    Rook.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 0,
      color: "white";
      )

    Rook.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 7,
      color: "white";
      )

    Knight.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 1,
      color: "white";
      )

    Knight.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 6,
      color: "white";
      )

    Bishop.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 2,
      color: "white";
      )

    Bishop.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 5,
      color: "white";
      )

    Queen.create(
      game_id: id,
      row_coordinate: 0,
      column_coordinate: 3,
      color: "white";
      )

    King.create(
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 4,
      color: "white";
      )

    # Build black pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        row_coordinate: 1,
        column_coordinate: i,
        color: "black";
        )

      Rook.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 0,
        color: "black";
        )

      Rook.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 7,
        color: "black";
        )

      Knight.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 1,
        color: "black";
        )

      Knight.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 6,
        color: "black";
        )

      Bishop.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 2,
        color: "black";
        )

      Bishop.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 5,
        color: "black";
        )

      Queen.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 3,
        color: "black";
        )

      King.create(
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 4,
        color: "black";
        )

    end
  end
