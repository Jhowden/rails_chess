class ChangeGamePlayerTurnTypeFromStringToInteger < ActiveRecord::Migration
  def change
    remove_column :games, :player_turn
    add_column :games, :player_turn, :integer
  end
end
