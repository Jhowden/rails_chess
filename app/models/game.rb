class Game < ActiveRecord::Base
  belongs_to :white_team, class_name: "User"
  belongs_to :black_team, class_name: "User"
  has_one :invitation

  validates_presence_of :board, :white_team_id, :black_team_id, :player_turn
  
  def self.determine_players_status( white_player_id, black_player_id, current_player_id )
    if current_player_id == white_player_id
      {
        current_player: 
          {id: white_player_id, team: :white},
        enemy_player:
          {id: black_player_id,team: :black}
      }
    else
      {
        current_player: 
          {id: black_player_id,team: :black},
        enemy_player:
          {id: white_player_id,team: :white}
      }
    end
  end
end