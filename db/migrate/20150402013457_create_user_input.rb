class CreateUserInput < ActiveRecord::Migration
  def change
    create_table :user_inputs do |t|
      t.string :inputs
      t.belongs_to :game
      t.timestamps
    end
  end
end
