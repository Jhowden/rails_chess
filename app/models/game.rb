class Game < ActiveRecord::Base
  belongs_to :white_team, class_name: "User"
  belongs_to :black_team, class_name: "User"
end