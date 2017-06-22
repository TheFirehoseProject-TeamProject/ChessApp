class AddEnpassantFlagToGameAndDeleteFromPieces < ActiveRecord::Migration[5.0]
  def change
    remove_column :pieces, :last_move_pawn_two_steps?, :boolean
    add_column :games, :last_move_pawn_two_steps?, :boolean
  end
end
