class Game < ApplicationRecord
  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true
  has_many :users
  has_many :pieces
  enum game_status: { in_progress: 0, checkmate: 1, stalemate: 2 }

  scope :available, -> { where('black_player_id IS NULL OR white_player_id IS NULL') }

  def check?
    color_opponent = turn == black_player_id ? 'white' : 'black'
    pieces.where(color: color_opponent).find_each do |piece|
      color_king = color_opponent == 'white' ? 'black' : 'white'
      other_king = pieces.find_by(type: 'King', color: color_king)
      return true if piece.valid_move?(other_king.column_coordinate, other_king.row_coordinate) && !piece.obstructed?(other_king.column_coordinate, other_king.row_coordinate)
    end
    false
  end

  def checkmate?
    return true if check? && !found_valid_move?
    false
  end

  def found_valid_move?
    reload
    found = false
    color_current_piece = turn == black_player_id ? 'black' : 'white'
    pieces.where(color: color_current_piece).find_each do |piece|
      0..8.times do |row|
        0..8.times do |column|
          next if !piece.valid_move?(column, row) || (column == piece.column_coordinate && row == piece.row_coordinate)
          saved_column = piece.column_coordinate
          saved_row = piece.row_coordinate
          en_passant_status = piece_capturable_by_en_passant
          destination_piece = pieces.find_by(column_coordinate: column, row_coordinate: row, is_on_board?: true)
          piece.move_to!(column, row) if (destination_piece.present? && destination_piece.color != piece.color) || destination_piece.nil?
          found = true unless check?
          undo_move_after_checkmate_test(piece, destination_piece, saved_row, saved_column, en_passant_status)
          return true if found == true
        end
      end
    end
    false
  end

  def undo_move_after_checkmate_test(piece, destination_piece, saved_row, saved_column, en_passant_status)
    piece.update(row_coordinate: saved_row, column_coordinate: saved_column)
    destination_piece.update(is_on_board?: true, row_coordinate: destination_piece.row_coordinate, column_coordinate: destination_piece.column_coordinate) unless destination_piece.nil?
    update(piece_capturable_by_en_passant: en_passant_status)
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
