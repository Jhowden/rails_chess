class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :sender
      t.belongs_to :receiver
      t.string :game_link
      
      t.timestamps
    end
  end
end
