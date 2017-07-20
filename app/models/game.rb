class Game < ApplicationRecord
  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true
  has_many :users
  has_many :pieces

  scope :available, -> { where('black_player_id IS NULL OR white_player_id IS NULL') }

  def set_game_status
    update(game_status: 0)
    update(turn: -1, game_status: 4) if draw?
    update(turn: -1, game_status: 1) if checkmate?
    update(turn: -1, game_status: 2) if stalemate?
    update(game_status: 3) if check?
  end

  def playing_against_yourself?
    return true if black_player.email.include?('@fake.com') && black_player.name == white_player.name
    false
  end

  def check?
    pieces.where(color: color_opponent).find_each do |piece|
      color_king = color_opponent == 'white' ? 'black' : 'white'
      other_king = pieces.find_by(type: 'King', color: color_king)
      return true if piece.valid_move?(other_king.column_coordinate, other_king.row_coordinate) &&
                     !piece.obstructed?(other_king.column_coordinate, other_king.row_coordinate)
    end
    false
  end

  def draw?
    return true if pieces.count == 2
    return true if pieces.count == 3 && (pieces.where(type: 'Knight').present? || pieces.where(type: 'Bishop').present?)
    return true if pieces.count == 4 && (pieces.where(type: 'Knight').count == 1 || pieces.where(type: 'Bishop').count == 1)
    false
  end

  def checkmate?
    return true if check? && !valid_move_possible
    false
  end

  def stalemate?
    return true if !check? && !valid_move_possible
    false
  end

  def valid_move_possible
    reload
    pieces.where(color: color_current_turn).find_each do |piece|
      0..8.times do |row|
        0..8.times do |column|
          next if !piece.valid_move?(column, row) ||
                  (column == piece.column_coordinate && row == piece.row_coordinate) ||
                  piece.obstructed?(column, row)
          original_column = piece.column_coordinate
          original_row = piece.row_coordinate
          en_passant_id = piece_capturable_by_en_passant
          en_passant_piece_row = Piece.find(en_passant_id).row_coordinate if en_passant_id.present?
          en_passant_piece_column = Piece.find(en_passant_id).column_coordinate if en_passant_id.present?
          destination_piece = piece.find_destination_piece(column, row)
          begin
            piece.move_to!(column, row)
          rescue
            false
          else
            undo_move_after_checkmate_test(piece, destination_piece, original_row, original_column)
            restore_en_passant_piece(en_passant_piece_row, en_passant_piece_column, en_passant_id) if en_passant_id.present?
            return true
          end
        end
      end
    end
    false
  end

  def empty_board?
    pieces.count.zero?
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

  def color_current_turn
    turn == black_player_id ? 'black' : 'white'
  end
  
  def restore_en_passant_piece(en_passant_piece_row, en_passant_piece_column, en_passant_id)
    Piece.find(en_passant_id).update(is_on_board?: true,
                                     row_coordinate: en_passant_piece_row,
                                     column_coordinate: en_passant_piece_column)
    update(piece_capturable_by_en_passant: en_passant_id)
  end

  private

  def undo_move_after_checkmate_test(piece, destination_piece, original_row, original_column)
    piece.update(row_coordinate: original_row, column_coordinate: original_column)
    return if destination_piece.nil?
    Piece.find(destination_piece.id).update(is_on_board?: true,
                                            row_coordinate: destination_piece.row_coordinate,
                                            column_coordinate: destination_piece.column_coordinate)
  end

  def color_opponent
    turn == black_player_id ? 'white' : 'black'
  end
end
