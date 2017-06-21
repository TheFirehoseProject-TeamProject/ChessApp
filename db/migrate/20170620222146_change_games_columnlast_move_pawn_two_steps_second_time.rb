class ChangeGamesColumnlastMovePawnTwoStepsSecondTime < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :last_move_en_passant_situation?, :piece_capturable_by_en_passant
    change_column :games, :piece_capturable_by_en_passant, :string
  end
end
