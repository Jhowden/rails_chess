require "pawn_diagonal/pawn_diagonal_movement"

class PawnDiagonal::PawnDiagonalRightDown < PawnDiagonal::PawnDiagonalMovement
  RANK_MOVE = -1
  
  def self.move( pawn, board )
    if board.move_forward_diagonally?( pawn, :right )
      possible_move( pawn, :previous, RANK_MOVE ) 
    end
  end
end