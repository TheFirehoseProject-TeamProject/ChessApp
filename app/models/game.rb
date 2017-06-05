class Game < ApplicationRecord
  has_many :users
  has_many :pieces

  belongs_to :white_player, class_name: 'User', optional: true
  belongs_to :black_player, class_name: 'User', optional: true

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }

  scope :available, -> { where('black_player_id IS NULL OR white_player_id IS NULL') }


  def populate_board!
    # this should create all 32 pieces with their initial X/Y coordinates.
    
    # Build white pieces

    (0..7).each do |i|
      Piece.create(
        type: 'Pawn',
        game_id: id,
        user_id: white_player.id,
        row_coordinate: 6,
        column_coordinate: i,
        color: "white",
        )
    end

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 0,
      color: "white"
      )

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 7,
      color: "white"
      )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 1,
      color: "white"
      )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 6,
      color: "white"
      )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 2,
      color: "white"
      )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 5,
      color: "white"
      )

    Piece.create(
      type: 'Queen',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 3,
      color: "white"
      )

    Piece.create(
      type: 'King',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 4,
      color: "white"
      )

    # Build black Piece
    (0..7).each do |i|
      Piece.create(
        type: 'Pawn',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 1,
        column_coordinate: i,
        color: "black"
        )
    end

      Piece.create(
        type: 'Rook',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 0,
        color: "black"
        )

      Piece.create(
        type: 'Rook',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 7,
        color: "black"
        )

      Piece.create(
        type: 'Knight',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 1,
        color: "black"
        )

      Piece.create(
        type: 'Knight',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 6,
        color: "black"
        )

      Piece.create(
        type: 'Bishop',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 2,
        color: "black"
        )

      Piece.create(
        type: 'Bishop',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 5,
        color: "black"
        )

      Piece.create(
        type: 'Queen',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 3,
        color: "black"
        )

      Piece.create(
        type: 'King',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 0,
        column_coordinate: 4,
        color: "black"
        )

  end
end
