class EnPassant::UpEnPassantMoves < EnPassant::EnPassantMoves
  CAPTURABLE_EN_PASSANT_RANK = 5
  RANK_AFTER_CAPTURING_BY_EN_PASSANT = 6
  
  def check_for_enpassant( navigation )
    board = pawn.board
    if is_legal_move?( pawn.position, navigation )
      enemy_position = Position.new( pawn.new_file_position( navigation ), CAPTURABLE_EN_PASSANT_RANK )
      potential_enemy_pawn = board.find_piece_on_board( enemy_position )
      legal_to_perform_en_passant?( potential_enemy_pawn )
    else
      false
    end
  end

  def possible_move_input( navigation )
    [
      pawn.position.file,
      pawn.position.rank,
      pawn.new_file_position( navigation ), 
      RANK_AFTER_CAPTURING_BY_EN_PASSANT, 
      EN_PASSANT_WORD_MARKER]
  end
end