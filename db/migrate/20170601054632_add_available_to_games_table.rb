class AddAvailableToGamesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :available, :boolean
  end
end
