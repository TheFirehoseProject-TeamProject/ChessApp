class CreatePieces < ActiveRecord::Migration[5.0]
  def change
    create_table :pieces do |t|
      t.string :type
      t.string :color
      t.boolean :is_on_board?
      t.integer :column_coordinate
      t.integer :row_coordinate
      t.timestamps
    end
  end
end
