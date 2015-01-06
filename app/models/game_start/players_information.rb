require "board_json_parser"

module GameStart
  class PlayersInformation
    attr_reader :status_map, :chess_board, :json_board, :current_player_id, :enemy_player_id,
      :current_player_team, :enemy_player_team

    def initialize( status_map, json_board )
      @status_map = status_map
      @json_board = json_board
      @chess_board = BoardJsonParser.parse_json_board json_board
      @current_player_id = status_map[:current_player][:id]
      @enemy_player_id = status_map[:enemy_player][:id]
      @current_player_team = status_map[:current_player][:team]
      @enemy_player_team = status_map[:enemy_player][:team]
    end
  end
end