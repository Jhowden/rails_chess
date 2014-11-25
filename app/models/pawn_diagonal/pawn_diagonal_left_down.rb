require "pawn_diagonal/pawn_diagonal_movement"

class PawnDiagonal::PawnDiagonalLeftDown < PawnDiagonal::PawnDiagonalMovement
  RANK_MOVE = -1
  
  def self.move( pawn, board )
    if board.move_forward_diagonally?( pawn, :left )
      possible_move( pawn, :next, RANK_MOVE )
    end
  end
end