class EnPassant::CapturedPieceEnPassantTeamIdentifier
  BLACK_CAPTURABLE_EN_PASSANT_RANK = 4
  WHITE_CAPTURABLE_EN_PASSANT_RANK = 5
  SINGLE_MOVE_COUNT = 1
  
  def self.select_pieces( enemy_pieces, team )
    case team
    when :black
      enemy_pieces.select { |piece| pawn_that_can_be_captured_through_en_passant( piece, BLACK_CAPTURABLE_EN_PASSANT_RANK ) }
    else
      enemy_pieces.select { |piece| pawn_that_can_be_captured_through_en_passant( piece, WHITE_CAPTURABLE_EN_PASSANT_RANK ) }
    end
  end
  
  private
  
  def self.pawn_that_can_be_captured_through_en_passant( piece, target_rank )
    !piece.captured? && 
    piece.is_a?( GamePieces::Pawn ) && 
    piece.position.rank == target_rank && 
    piece.move_counter == SINGLE_MOVE_COUNT && 
    piece.can_be_captured_en_passant?
  end
end