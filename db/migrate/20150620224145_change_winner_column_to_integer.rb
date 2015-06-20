class ChangeWinnerColumnToInteger < ActiveRecord::Migration
  def change
    remove_column :games, :winner
    add_column :games, :winner, :integer
  end
end
