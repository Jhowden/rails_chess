class AddGameIdToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :game
  end
end
