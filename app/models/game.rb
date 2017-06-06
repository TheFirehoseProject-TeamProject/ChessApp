class Game < ApplicationRecord
  belongs_to :black_player, class_name: 'User'
  belongs_to :white_player, class_name: 'User'
  has_many :users
  has_many :pieces

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
        color: 'white',
        image: '/assets/images/WhitePawn.png'
      )
    end

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 0,
      color: 'white',
      image: '/assets/images/WhiteRook.png'
    )

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 7,
      color: 'white',
      image: '/assets/images/WhiteRook.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 1,
      color: 'white',
      image: '/assets/images/WhiteKnight.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 6,
      color: 'white',
      image: '/assets/images/WhiteKnight.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 2,
      color: 'white',
      image: '/assets/images/WhiteBishop.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 5,
      color: 'white',
      image: '/assets/images/WhiteBishop.png'
    )

    Piece.create(
      type: 'Queen',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 3,
      color: 'white',
      image: '/assets/images/WhiteQueen.png'
    )

    Piece.create(
      type: 'King',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 7,
      column_coordinate: 4,
      color: 'white',
      image: '/assets/images/WhiteKing.png'
    )

    # Build black Piece
    (0..7).each do |i|
      Piece.create(
        type: 'Pawn',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 1,
        column_coordinate: i,
        color: 'black',
        image: '/assets/images/BlackPawn.png'
      )
    end

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 0,
      color: 'black',
      image: '/assets/images/BlackRook.png'
    )

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 7,
      color: 'black',
      image: '/assets/images/BlackRook.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 1,
      color: 'black',
      image: '/assets/images/BlackKnight.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 6,
      color: 'black',
      image: '/assets/images/BlackKnight.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 2,
      color: 'black',
      image: '/assets/images/BlackBishop.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 5,
      color: 'black',
      image: '/assets/images/BlackBishop.png'
    )

    Piece.create(
      type: 'Queen',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 3,
      color: 'black',
      image: '/assets/images/BlackQueen.png'
    )

    Piece.create(
      type: 'King',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 0,
      column_coordinate: 4,
      color: 'black',
      image: '/assets/images/BlackKing.png'
    )
  end
end
