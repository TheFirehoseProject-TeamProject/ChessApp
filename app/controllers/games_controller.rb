class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[show new create play_against_yourself]
  skip_before_action :verify_authenticity_token, only: :show
  helper_method :current_game

  def new; end

  def index
    @available_games = Game.available
  end

  def create
    @game = Game.create(white_player_id: current_user.id, turn: current_user.id)
    Pusher.trigger('static_page_channel', 'new_game_created', message: 'new_game_created')
  end

  def show
    @game = current_game
    current_game.update(black_player_id: current_user.id) if current_user.id != current_game.white_player_id
    current_game.populate_board! if current_game.black_player_id && current_game.white_player_id && current_game.empty_board?
    @waiting = current_game.black_player_id.nil? || current_game.white_player_id.nil? ? true : false
    Pusher.trigger('game_' + @game.id.to_s, 'second_player_joined', message: 'second_player_joined') if @waiting == false
    @board = current_board
  end

  def play_against_yourself
    email = 'email' + Time.now.to_i.to_s + '@fake.com'
    fake_user = User.create(email: email, password: '123456', password_confirmation: '123456')
    current_game.update(black_player_id: fake_user.id)
    redirect_to game_path(current_game.id)
  end

  def game_available
    return render plain: 'true' if !current_game.white_player_id || !current_game.black_player_id
    render plain: 'false'
  end

  def update
    @game = Game.find(params[:id])
  end

  private

  def current_board
    pieces = current_game.pieces
    board = Array.new(8) { Array.new(8) { { piece: nil } } }
    (0..7).each do |row_index|
      (0..7).each do |column_index|
        board[row_index][column_index] = if column_index.even? && row_index.even? || row_index.odd? && column_index.odd?
                                           { class: 'black_field' }
                                         else
                                           { class: 'white_field' }
                                         end
      end
    end

    pieces.each do |piece|
      board[piece.row_coordinate][piece.column_coordinate][:piece] = piece if piece.is_on_board?
    end

    board
  end

  def current_game
    @current_game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id)
  end
end
