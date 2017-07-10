class AddMovedToPiece < ActiveRecord::Migration[5.0]
  def change
    add_column :pieces, :moved?, :boolean, default: false
  end
end
