module GameStart
  class PlayersInformation
    attr_reader :chess_board, :json_board, :current_team_id, :enemy_team_id,
      :current_team, :enemy_team

    def initialize( status_map, json_board )
      @json_board = json_board
      @current_team_id = status_map[:current_player][:id]
      @enemy_team_id = status_map[:enemy_player][:id]
      @current_team = status_map[:current_player][:team]
      @enemy_team = status_map[:enemy_player][:team]
    end
  end
end