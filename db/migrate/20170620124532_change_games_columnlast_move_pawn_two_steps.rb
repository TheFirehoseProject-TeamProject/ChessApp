class ChangeGamesColumnlastMovePawnTwoSteps < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :last_move_pawn_two_steps?, :last_move_en_passant_situation?
  end
end
