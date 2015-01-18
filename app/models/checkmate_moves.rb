require "find_pieces/find_team_pieces"

module CheckmateMoves
  def self.find_king( current_team, board )
    FindPieces::FindTeamPieces.find_king_piece( current_team, board )
  end
  
  def self.find_team_pieces( enemy_team, board )
    FindPieces::FindTeamPieces.find_pieces( enemy_team, board )
  end
end

require "checkmate_moves/block_piece_moves"
require "checkmate_moves/capture_piece_moves"
require "checkmate_moves/king_escape_moves"