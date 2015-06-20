require "find_pieces/find_team_pieces"

module Castle
  WHITE_ROOK_RANK_INDEX = 0
  BLACK_ROOK_RANK_INDEX = 7
  
  WHITE_ROOK_RANK = 8
  BLACK_ROOK_RANK = 1
  
  KINGSIDE_ROOK_FILE_INDEX = 7
  QUEENSIDE_ROOK_FILE_INDEX = 0
  
  def self.find_rook( current_team, board, file_index )
    rank_index = current_team == :white ? Castle::WHITE_ROOK_RANK_INDEX : Castle::BLACK_ROOK_RANK_INDEX
    FindPieces::FindTeamPieces.
      find_kingside_rook( current_team, board, file_index, rank_index )
  end
  
  def self.find_king( current_team, board )
    FindPieces::FindTeamPieces.
      find_king_piece( current_team, board )
  end

  def self.valid_move?( king, players_info, board, file )
    starting_position = king.position.dup
    king.update_piece_position( Position.new( file, king.position.rank ) )
    board.update_board king
    board.remove_old_position starting_position
    king_not_in_check?( board, king, players_info.enemy_team )
  end

  private

  def self.king_not_in_check?( updated_board, king, enemy_team )
    !GameStart::Check.king_in_check?(
      king,
      FindPieces::FindTeamPieces.
        find_pieces( enemy_team, updated_board ) )
  end
end

require "castle/king_side"
require "castle/queen_side"