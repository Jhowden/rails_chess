module CastleMovementHelpers
  WHITE_ROOK_RANK_INDEX = 0
  BLACK_ROOK_RANK_INDEX = 7
  
  WHITE_ROOK_RANK = 8
  BLACK_ROOK_RANK = 1
  
  KINGSIDE_ROOK_FILE_INDEX = 7
  QUEENSIDE_ROOK_FILE_INDEX = 0
  
  def find_castle_king( board )
   find_king( players_info.current_team, board )
  end

  def find_castle_rook( board, file_index )
    find_rook( players_info.current_team, board, file_index )
  end

  def valid_move?( king, players_info, board, file )
    starting_position = king.position.dup
    king.update_piece_position( Position.new( file, king.position.rank ) )
    board.update_board king
    board.remove_old_position starting_position
    king_not_in_check?( board, king, players_info.enemy_team )
  end

  def legal_to_castle?( rook, king, file_container )
    if first_move?( king.move_counter, rook.move_counter ) && !spaces_occupied?( file_container )
      boolean_moves = file_container.map do |file|
      dummy_board = Board.new(
        BoardJsonParser.parse_json_board( players_info.json_board ) )
      valid_move?( king, players_info, dummy_board, file )
    end
      boolean_moves.all? { |boolean| boolean }
    else
      false
    end
  end
  
  private
  
  def find_rook( current_team, board, file_index )
    rank_index = current_team == :white ? WHITE_ROOK_RANK_INDEX : BLACK_ROOK_RANK_INDEX
    FindPieces::FindTeamPieces.
      find_kingside_rook( current_team, board, file_index, rank_index )
  end
  
  def find_king( current_team, board )
    FindPieces::FindTeamPieces.
      find_king_piece( current_team, board )
  end
  
  def spaces_occupied?( file_container )
    file_container.map { |file|
      occupied_space?( file )
    }.any? { |boolean| boolean }
  end
  
  def occupied_space?( file )
    rank = :white == players_info.current_team ? WHITE_ROOK_RANK : BLACK_ROOK_RANK
    piece = board.
      find_piece_on_board( Position.new( file, rank ) )
    piece.team
  end
  
  def first_move?( king_movement_counter, rook_movement_counter )
    [king_movement_counter, rook_movement_counter].all? { |counter| counter == 0 }
  end

  def king_not_in_check?( updated_board, king, enemy_team )
    !GameStart::Check.king_in_check?(
      king,
      FindPieces::FindTeamPieces.
        find_pieces( enemy_team, updated_board ) )
  end
end