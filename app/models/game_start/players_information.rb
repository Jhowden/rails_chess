require "board_json_parser"

module GameStart
  class PlayersInformation
    attr_reader :status_map, :chess_board, :json_board, :current_player_id, :enemy_player_id, 
      :enemy_player_pieces, :current_player_pieces, :current_player_king,
      :enemy_player_king
    
    def initialize( status_map, json_board )
      @status_map = status_map
      @json_board = json_board
      @chess_board = BoardJsonParser.parse_json_board json_board
      @current_player_id = status_map[:current_player][:id]
      @enemy_player_id = status_map[:enemy_player][:id]
      @enemy_player_pieces = find_team_pieces status_map[:enemy_player][:team]
      @enemy_player_king = find_king status_map[:enemy_player][:team]
      @current_player_pieces = find_team_pieces status_map[:current_player][:team]
      @current_player_king = find_king status_map[:current_player][:team]
    end
    
    private
    
    def find_team_pieces team
      pieces = chess_board.map { |row|
        row.select {|location| !location.nil? && 
          location.team == team &&
            location.captured? == false }
      }.flatten.each { |piece| piece.board = Board.new( chess_board ) }
      insert_board_on_pieces_in_board pieces
      pieces
    end
    
    def find_king team
      chess_board.map { |row|
        row.select { |location| !location.nil? && 
          location.class == GamePieces::King && 
            location.team == team }
      }.flatten.first
    end
    
    def insert_board_on_pieces_in_board pieces
      pieces.each do |piece|
        piece.board.chess_board.each do |row|
          row.each do |location|
            location.board = Board.new( chess_board ) unless location.nil?
          end
        end
      end
    end
  end
end