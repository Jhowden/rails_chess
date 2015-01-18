require "checkmate_moves"
require "board_json_parser"
require "try_move"

module CheckmateMoves
  class KingEscapeMoves
    extend TryMove

    def self.find_moves( json_board, player_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      king = CheckmateMoves.find_king( player_team, board )
      
      king.determine_possible_moves.map { |move|
        position = Position.new( move.first, move.last )
        testing_board = Board.new( BoardJsonParser.
          parse_json_board( json_board ) )
        if out_of_check?( CheckmateMoves.find_king( player_team, testing_board ), 
          testing_board, position, CheckmateMoves.find_team_pieces( enemy_team, testing_board ) )
          [king.position.file, king.position.rank ].
            concat( [position.file, position.rank] )
        end
      }.compact
    end
  end
end