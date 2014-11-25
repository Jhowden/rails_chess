class Invitation < ActiveRecord::Base
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :game

  validates_presence_of :sender_id, :receiver_id, :game_link, :game_id
  
  def self.create_game_link game_id
    "game/#{game_id}/home"
  end
end