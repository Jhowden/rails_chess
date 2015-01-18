require "find_pieces/find_team_pieces"
require "board_json_parser"
require "try_move"

module CheckmateMoves
  class CapturePieceMoves
    extend TryMove
    
    def self.find_moves( json_board, current_team, enemy_team )
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      threatening_pieces_position = find_threatening_pieces( 
        enemy_team, current_team, board )
      return [] if threatening_pieces_position.size >= 2
      team_pieces = find_team_pieces( current_team, board ).
        reject { |piece| piece.class == GamePieces::King }
      team_pieces.map { |piece|
        possible_moves = piece.determine_possible_moves
        if possible_moves.include?( 
            [threatening_pieces_position.first.file, 
             threatening_pieces_position.first.rank] 
            )
          original_piece_position = piece.position.dup
          testing_board = Board.new( BoardJsonParser.
            parse_json_board( json_board ) )
          if captured_piece?( 
               find_king( current_team, testing_board ),
               piece, 
               testing_board, 
               threatening_pieces_position.first, 
               find_team_pieces( enemy_team, testing_board ) 
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
    
    def self.find_threatening_pieces( enemy_team, current_team, board )
      enemy_pieces = find_team_pieces( enemy_team, board )
      king = find_king( current_team, board )
      enemy_pieces.map { |piece|
        possible_piece_moves = piece.determine_possible_moves
        if possible_piece_moves.include?( [king.position.file, king.position.rank] )
          Position.new( piece.position.file, piece.position.rank )
        end
      }.compact
    end
    
    def self.find_king( current_team, board )
      FindPieces::FindTeamPieces.find_king_piece( current_team, board )
    end
    
    def self.find_team_pieces( enemy_team, board )
      FindPieces::FindTeamPieces.find_pieces( enemy_team, board )
    end
  end
end