class ChangePiecesColumnisOnBoard < ActiveRecord::Migration[5.0]
  def change
    change_column :pieces, :is_on_board?, :boolean, default: true
  end
end
