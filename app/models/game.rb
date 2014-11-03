class Game < ActiveRecord::Base
  belongs_to :white_team, class_name: "User"
  belongs_to :black_team, class_name: "User"
  has_one :invitation

  validates_presence_of :board, :white_team_id, :black_team_id, :player_turn
end