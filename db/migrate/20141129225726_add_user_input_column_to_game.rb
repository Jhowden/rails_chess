class AddUserInputColumnToGame < ActiveRecord::Migration
  def change
    add_column :games, :user_input, :string, array: true, default: []
  end
end
