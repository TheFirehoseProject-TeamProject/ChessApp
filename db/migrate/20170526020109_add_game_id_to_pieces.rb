class AddGameIdToPieces < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :game_id, :integer
    add_index :pieces, :game_id
  end
end
