require "checkmate_moves"
require "board_json_parser"
require "escape_checkmate"

module CheckmateMoves
  class CapturePieceMoves
    extend EscapeCheckmate
    
    def self.find_moves( json_board, current_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      threatening_pieces_position = find_threatening_pieces( 
        enemy_team, current_team, board )
      return [] if threatening_pieces_position.size >= 2 || threatening_pieces_position.empty?
      team_pieces( current_team, board ).map { |piece|
        possible_moves = CheckmateMoves.
          transform_moves( piece.determine_possible_moves )
        if possible_moves.include?( 
            [threatening_pieces_position.first.file, 
             threatening_pieces_position.first.rank] 
            )
          original_piece_position = piece.position.dup
          replicate_board = Board.new( BoardJsonParser.
            parse_json_board( json_board ) )
          if king_protected?( 
               CheckmateMoves.find_king( current_team, replicate_board ),
               piece, 
               replicate_board, 
               threatening_pieces_position.first, 
               CheckmateMoves.find_team_pieces( enemy_team, replicate_board ) 
             )
            [original_piece_position.file, original_piece_position.rank].
              concat(
                [
                  threatening_pieces_position.first.file, 
                  threatening_pieces_position.first.rank
                ] 
              )
          end
        end
      }.compact
    end
    
    private

    def self.team_pieces( current_team, board )
      return @team_pieces if @team_pieces
      @team_pieces = CheckmateMoves.find_team_pieces( current_team, board ).
        reject { |piece| piece.class == GamePieces::King }
    end
    
    def self.find_threatening_pieces( enemy_team, current_team, board )
      enemy_pieces = CheckmateMoves.find_team_pieces( enemy_team, board )
      king = CheckmateMoves.find_king( current_team, board )
      enemy_pieces.map { |piece|
        possible_piece_moves = CheckmateMoves.transform_moves( 
          piece.determine_possible_moves )
        if possible_piece_moves.include?( [king.position.file, king.position.rank] )
          Position.new( piece.position.file, piece.position.rank )
        end
      }.compact
    end
  end
end