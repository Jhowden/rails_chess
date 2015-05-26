require "find_pieces/find_team_pieces"

module Castle
  WHITE_ROOK_RANK_INDEX = 0
  BLACK_ROOK_RANK_INDEX = 7
  
  def self.find_rook( current_team, board, file_index )
    rank_index = current_team == :white ? Castle::WHITE_ROOK_RANK_INDEX : Castle::BLACK_ROOK_RANK_INDEX
    FindPieces::FindTeamPieces.
      find_kingside_rook( current_team, board, file_index, rank_index )
  end
  
  def self.find_king( current_team, board )
    FindPieces::FindTeamPieces.
      find_king_piece( current_team, board )
  end
end

require "castle/king_side"