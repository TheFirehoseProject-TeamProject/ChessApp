class Game < ApplicationRecord
  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true
  has_many :users
  has_many :pieces

  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }

  scope :available, -> { where('black_player_id IS NULL OR white_player_id IS NULL') }

  def check?
    pieces.each do |piece|
      color = piece.color
      if color == 'white'
        other_king = pieces.find_by(type: 'King', color: 'black')
        return true if piece.valid_move?(other_king.column_coordinate, other_king.row_coordinate)
      elsif color == 'black'
        other_king = pieces.find_by(type: 'King', color: 'white')
        return true if piece.valid_move?(other_king.column_coordinate, other_king.row_coordinate)
      end
    end
    false
  end

  def checkmate?
    return true if check? && !king_can_move? && !found_valid_move?
  end

  def found_valid_move?
    return true if turn == black_player_id && found_valid_move_for_black?
    return true if turn == white_player_id && found_valid_move_for_white?
    false
  end

  def found_valid_move_for_black?
    game.pieces.find_by(color: 'black').each do |piece|
      0..7.each do |row|
        0..7.each do |column|
          next unless piece.valid_move?(column, row)
          new_position = create_checkmate_postion
          piece_positioncheck = find_piece(new_position, piece.row_coordinate, piece.column_coordinate)
          piece_positioncheck.move_to!(column, row)
          next if new_position.check?
          return true
        end
      end
    end
  end

  def found_valid_move_for_white?
    game.pieces.find_by(color: 'white').each do |piece|
      0..7.each do |row|
        0..7.each do |column|
          next unless piece.valid_move?(column, row)
          new_position = create_checkmate_postion
          piece_positioncheck = find_piece(new_position, piece.row_coordinate, piece.column_coordinate)
          piece_positioncheck.move_to!(column, row)
          next if new_position.check?
          return true
        end
      end
    end
  end

  def create_checkmate_postion
    new_position = Game.new(white_player_id: white_player_id, black_player_id: black_player_id)
    pieces.all.find_each do |piece|
      Piece.create(game_id: piece.game_id, user_id: piece.user_id, color: piece.color, type: piece.type)
    end
    new_position
  end

  def find_piece(position, row, column)
    position.pieces.find_by(row_coordinate: row, column_coordinate: column)
  end

  def king_can_move?
    king = turn == black_player_id? ? pieces.find_by(type: 'King', color: 'black') : pieces.find_by(type: 'King', color: 'white')
    return true if king.valid_move?(king.column_coordinate + 1, king.row_coordinate)
    return true if king.valid_move?(king.column_coordinate - 1, king.row_coordinate)
    return true if king.valid_move?(king.column_coordinate, king.row_coordinate + 1)
    return true if king.valid_move?(king.column_coordinate, king.row_coordinate - 1)
    return true if king.valid_move?(king.column_coordinate + 1, king.row_coordinate + 1)
    return true if king.valid_move?(king.column_coordinate + 1, king.row_coordinate - 1)
    return true if king.valid_move?(king.column_coordinate - 1, king.row_coordinate - 1)
    return true if king.valid_move?(king.column_coordinate - 1, king.row_coordinate + 1)
    false
  end

  def populate_board!
    (0..7).each do |i|
      Piece.create(
        type: 'Pawn',
        game_id: id,
        user_id: white_player.id,
        row_coordinate: 1,
        column_coordinate: i,
        color: 'white',
        image: 'pieces/WhitePawn.png'
      )
    end

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 0,
      color: 'white',
      image: 'pieces/WhiteRook.png'
    )

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 7,
      color: 'white',
      image: 'pieces/WhiteRook.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 1,
      color: 'white',
      image: 'pieces/WhiteKnight.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 6,
      color: 'white',
      image: 'pieces/WhiteKnight.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 2,
      color: 'white',
      image: 'pieces/WhiteBishop.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 5,
      color: 'white',
      image: 'pieces/WhiteBishop.png'
    )

    Piece.create(
      type: 'Queen',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 3,
      color: 'white',
      image: 'pieces/WhiteQueen.png'
    )

    Piece.create(
      type: 'King',
      game_id: id,
      user_id: white_player.id,
      row_coordinate: 0,
      column_coordinate: 4,
      color: 'white',
      image: 'pieces/WhiteKing.png'
    )

    (0..7).each do |i|
      Piece.create(
        type: 'Pawn',
        game_id: id,
        user_id: black_player.id,
        row_coordinate: 6,
        column_coordinate: i,
        color: 'black',
        image: 'pieces/BlackPawn.png'
      )
    end

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 0,
      color: 'black',
      image: 'pieces/BlackRook.png'
    )

    Piece.create(
      type: 'Rook',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 7,
      color: 'black',
      image: 'pieces/BlackRook.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 1,
      color: 'black',
      image: 'pieces/BlackKnight.png'
    )

    Piece.create(
      type: 'Knight',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 6,
      color: 'black',
      image: 'pieces/BlackKnight.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 2,
      color: 'black',
      image: 'pieces/BlackBishop.png'
    )

    Piece.create(
      type: 'Bishop',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 5,
      color: 'black',
      image: 'pieces/BlackBishop.png'
    )

    Piece.create(
      type: 'Queen',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 3,
      color: 'black',
      image: 'pieces/BlackQueen.png'
    )

    Piece.create(
      type: 'King',
      game_id: id,
      user_id: black_player.id,
      row_coordinate: 7,
      column_coordinate: 4,
      color: 'black',
      image: 'pieces/BlackKing.png'
    )
  end

  def empty_board?
    pieces.count.zero?
  end
end
