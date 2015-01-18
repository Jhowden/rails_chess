require "find_pieces/find_team_pieces"
require "board_json_parser"
require "try_move"

module CheckmateMoves
  class KingEscapeMoves
    extend TryMove

    def self.find_moves( json_board, player_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      king = find_king( player_team, board )
      
      king.determine_possible_moves.map { |move|
        position = Position.new( move.first, move.last )
        testing_board = Board.new( BoardJsonParser.
          parse_json_board( json_board ) )
        if out_of_check?( find_king( player_team, testing_board ), 
          testing_board, position, find_team_pieces( enemy_team, testing_board ) )
          [king.position.file, king.position.rank ].
            concat( [position.file, position.rank] )
        end
      }.compact
    end
    
    private
    
    def self.find_king( player_team, board )
      FindPieces::FindTeamPieces.find_king_piece( player_team, board )
    end
    
    def self.find_team_pieces( enemy_team, board )
      FindPieces::FindTeamPieces.find_pieces( enemy_team, board )
    end
  end
end