class AddtwoStepsPawnToPieces < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :last_move_pawn_two_steps?, :boolean
  end
end
