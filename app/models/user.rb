class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  
  has_many :sent_invitations, foreign_key: "sender_id", class_name: "Invitation"
  has_many :received_invitations, foreign_key: "receiver_id", class_name: "Invitation"

  has_many :white_team_games, foreign_key: "white_team_id", class_name: "Game"
  has_many :black_team_games, foreign_key: "black_team_id", class_name: "Game"
  
  def fullname
    [first_name, last_name].join( " " )
  end
end
