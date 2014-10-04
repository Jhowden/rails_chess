class Game < ActiveRecord::Base
  belongs_to :white_team, class_name: "User"
  belongs_to :black_team, class_name: "User"
  has_one :invitation

  serialize :board
  validates_presence_of :board, :white_team, :black_team
end