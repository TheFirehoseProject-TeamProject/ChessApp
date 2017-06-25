class ChangeGamesColumnpieceCapturableById < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :piece_capturable_by_en_passant, :string
    add_column :games, :piece_capturable_by_en_passant, :integer
  end
end
