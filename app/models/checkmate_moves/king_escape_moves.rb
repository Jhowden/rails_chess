require "checkmate_moves"
require "board_json_parser"
require "escape_checkmate"

module CheckmateMoves
  class KingEscapeMoves
    extend EscapeCheckmate

    def self.find_moves( json_board, player_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      king = CheckmateMoves.find_king( player_team, board )
      
      king.determine_possible_moves.map { |move|
        target_location = move.last( 2 )
        position = Position.new( target_location.first, target_location.last )
        replicate_board = Board.new( BoardJsonParser.
          parse_json_board( json_board ) )
        if king_escaped?( CheckmateMoves.find_king( player_team, replicate_board ), 
          replicate_board, position, CheckmateMoves.find_team_pieces( enemy_team, replicate_board ) )
          [king.position.file, king.position.rank ].
            concat( [position.file, position.rank] )
        end
      }.compact
    end
  end
end