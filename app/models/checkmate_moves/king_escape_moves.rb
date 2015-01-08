require "find_pieces/find_team_pieces"
require "board_json_parser"
require "try_move"

module CheckmateMoves
  class KingEscapeMoves
    extend TryMove

    def self.find_moves( json_board, current_player_team, enemy_player_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      king = find_king( current_player_team, board )
      
      king.determine_possible_moves.map { |move|
        new_board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
        if out_of_check?( find_king( current_player_team, new_board ), 
          new_board, move, find_enemy_pieces( enemy_player_team, new_board ) )
          [king.position.file, king.position.rank ].concat move
        end
      }.compact
    end
    
    private
    
    def self.find_king( current_player_team, board )
      FindPieces::FindTeamPieces.find_king_piece( current_player_team, board )
    end
    
    def self.find_enemy_pieces( enemy_player_team, board )
      FindPieces::FindTeamPieces.find_pieces( enemy_player_team, board )
    end
  end
end