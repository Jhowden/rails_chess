require "checkmate_moves/king_escape_moves"
require "checkmate_moves/capture_piece_moves"
require "checkmate_moves/block_piece_moves"

module GameStart
  class Checkmate
    attr_reader :json_board, :current_team, :enemy_team
    
    def initialize( json_board, current_team, enemy_team )
      @json_board = json_board
      @current_team = current_team
      @enemy_team = enemy_team
    end
    
    def find_checkmate_escape_moves()
      moves = find_possible_escape_moves( 
        json_board, current_team, enemy_team ) 
      moves.uniq.reject { |move| move == [true] }.
        map{ |move| move.map( &:to_s ).join }
    end
    
    def match_finished?( updated_json_board )
      moves = find_possible_escape_moves(
        updated_json_board, enemy_team, current_team )
      moves.empty?
    end
    
    private
    
    def find_possible_escape_moves( json_board, has_the_move_team, made_team )
      possible_moves = []
      possible_moves.concat( find_king_escape_moves( 
        json_board, has_the_move_team, made_team ) )
      possible_moves.concat( capture_piece_moves( 
        json_board, has_the_move_team, made_team ) )
      possible_moves.concat( block_piece_moves( 
        json_board, has_the_move_team, made_team ) )
      possible_moves
    end
    
    def find_king_escape_moves( json_board, has_the_move_team, made_team )
      CheckmateMoves::KingEscapeMoves.
        find_moves( json_board, has_the_move_team, made_team )
    end
    
    def capture_piece_moves( json_board, has_the_move_team, made_team )
      CheckmateMoves::CapturePieceMoves.
        find_moves( json_board, has_the_move_team, made_team )
    end
    
    def block_piece_moves( json_board, has_the_move_team, made_team )
      CheckmateMoves::BlockPieceMoves.
        find_moves( json_board, has_the_move_team, made_team )
    end
  end
end