require "checkmate_moves"
require "board_json_parser"
require "escape_checkmate"

module CheckmateMoves
  class BlockPieceMoves
    extend EscapeCheckmate
    
    def self.find_moves( json_board, current_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      threatening_pieces_moves = find_threatening_pieces_moves( 
        enemy_team, current_team, board )
      team_pieces = CheckmateMoves.find_team_pieces( current_team, board ).
        reject { |piece| piece.class == GamePieces::King }
      team_pieces.map { |piece|
        possible_moves = CheckmateMoves.transform_moves( 
          piece.determine_possible_moves )
        original_piece_position = piece.position.dup
        threatening_pieces_moves.map do |move|
          position = Position.new( move.first, move.last )
          if possible_moves.include? move
            replicate_board = Board.new( BoardJsonParser.
              parse_json_board( json_board ) )
            if king_protected?( 
                 CheckmateMoves.find_king( current_team, replicate_board ),
                 piece,
                 replicate_board,
                 position,
                 CheckmateMoves.find_team_pieces( enemy_team, replicate_board )
               )
               [original_piece_position.file, original_piece_position.rank].
                 concat( [position.file, position.rank] )
            end
          end
        end
      }.flatten( 1 ).compact
    end
    
    private
      
    def self.find_threatening_pieces_moves( enemy_team, current_team, board )
      enemy_pieces = CheckmateMoves.find_team_pieces( enemy_team, board )
      king = CheckmateMoves.find_king( current_team, board )
      enemy_pieces.map { |piece|
        possible_piece_moves = CheckmateMoves.transform_moves( 
          piece.determine_possible_moves )
        if possible_piece_moves.include?( [king.position.file, king.position.rank] )
          possible_piece_moves
        end
      }.compact.flatten 1
    end
  end
end