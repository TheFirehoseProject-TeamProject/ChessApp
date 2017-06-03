class DeleteAvailableColumnFromGame < ActiveRecord::Migration[5.0]
  def change
    remove_column :games, :available, :boolean
  end
end
