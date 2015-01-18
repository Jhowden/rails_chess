require "checkmate_moves/king_escape_moves"
require "checkmate_moves/capture_piece_moves"
require "checkmate_moves/block_piece_moves"

module GameStart
  class Checkmate
    attr_reader :json_board, :current_player_team, :enemy_player_team
    
    def initialize json_board, current_player_team, enemy_player_team
      @json_board = json_board
      @current_player_team = current_player_team
      @enemy_player_team = enemy_player_team
    end
    
    def find_checkmate_escape_moves
      possible_moves = []
      possible_moves.concat( CheckmateMoves::KingEscapeMoves.
        find_moves( json_board, current_player_team, enemy_player_team ) )
      possible_moves.concat( CheckmateMoves::CapturePieceMoves.
          find_moves( json_board, current_player_team, enemy_player_team ) )
      possible_moves.concat( CheckmateMoves::BlockPieceMoves.
        find_moves( json_board, current_player_team, enemy_player_team ) )
      possible_moves
    end
  end
end