class RemoveUserInputFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :user_input, :string
  end
end
