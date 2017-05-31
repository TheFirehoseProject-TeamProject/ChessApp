class Game < ApplicationRecord
  has_many :users
  has_many :pieces

  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }

  def populate_board!
    # this should create all 32 pieces with their initial X/Y coordinates.
    
    # Build white pieces

    (0..7).each do |i|
      pieces.create(
        type: 'Pawn',
        game_id: id,
        row_coordinate: 6,
        column_coordinate: i,
        color: "white",
        )
    end

    pieces.create(
      type: 'Rook',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 0,
      color: "White"
      )

    pieces.create(
      type: 'Rook',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 7,
      color: "white"
      )

    pieces.create(
      type: 'Knight',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 1,
      color: "white"
      )

    pieces.create(
      type: 'Knight',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 6,
      color: "white"
      )

    pieces.create(
      type: 'Bishop',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 2,
      color: "white"
      )

    pieces.create(
      type: 'Bishop',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 5,
      color: "white"
      )

    pieces.create(
      type: 'Queen',
      game_id: id,
      row_coordinate: 0,
      column_coordinate: 3,
      color: "white"
      )

    pieces.create(
      type: 'King',
      game_id: id,
      row_coordinate: 7,
      column_coordinate: 4,
      color: "white"
      )

    # Build black pieces
    (0..7).each do |i|
      pieces.create(
        type: 'Pawn',
        game_id: id,
        row_coordinate: 1,
        column_coordinate: i,
        color: "Black"
        )
    end

      pieces.create(
        type: 'Rook',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 0,
        color: "black"
        )

      pieces.create(
        type: 'Rook',
        row_coordinate: 0,
        column_coordinate: 7,
        color: "black"
        )

      pieces.create(
        type: 'Knight',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 1,
        color: "black"
        )

      pieces.create(
        type: 'Knight',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 6,
        color: "black"
        )

      pieces.create(
        type: 'Bishop',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 2,
        color: "black"
        )

      pieces.create(
        type: 'Bishop',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 5,
        color: "black"
        )

      pieces.create(
        type: 'Queen',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 3,
        color: "black"
        )

      pieces.create(
        type: 'King',
        game_id: id,
        row_coordinate: 0,
        column_coordinate: 4,
        color: "black"
        )

  end
end
