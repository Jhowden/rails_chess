class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :board
      t.belongs_to :black_team
      t.belongs_to :white_team
      t.string :player_turn

      t.timestamps
    end
  end
end
