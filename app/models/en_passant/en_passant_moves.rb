require "file_checker_factory"

class EnPassant::EnPassantMoves
  include MoveValidations
  
  EN_PASSANT_WORD_MARKER = "e.p."
  SINGLE_MOVE_COUNT = 1
  
  attr_reader :pawn
  
  def initialize( pawn )
    @pawn = pawn
  end
  
  def legal_to_perform_en_passant?( potential_enemy_pawn )
    potential_enemy_pawn.is_a?( GamePieces::Pawn ) && 
    potential_enemy_pawn.move_counter == SINGLE_MOVE_COUNT && 
    potential_enemy_pawn.can_be_captured_en_passant?
  end
  
  def is_legal_move?( position, navigation )
    file = FileCheckerFactory.create_for( position, navigation )
    rank = position.rank_position_converter
    legal_move?( file, rank )
  end
end