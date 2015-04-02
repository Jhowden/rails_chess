class Game < ActiveRecord::Base
  belongs_to :white_team, class_name: "User"
  belongs_to :black_team, class_name: "User"
  has_one :invitation
  
  has_many :user_inputs

  validates_presence_of :board, :white_team_id, :black_team_id, :player_turn
  
  def determine_players_status()
    if player_turn == white_team_id
      {
        current_player: 
          {id: white_team_id, team: :white},
        enemy_player:
          {id: black_team_id, team: :black}
      }
    else
      {
        current_player: 
          {id: black_team_id, team: :black},
        enemy_player:
          {id: white_team_id, team: :white}
      }
    end
  end
end