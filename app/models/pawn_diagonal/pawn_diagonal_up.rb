require "pawn_diagonal/pawn_diagonal_left_up"
require "pawn_diagonal/pawn_diagonal_right_up"

class PawnDiagonal::PawnDiagonalUp
  def self.move_diagonal( pawn, board, direction )
    if const_defined?( "PawnDiagonal::PawnDiagonal#{direction.capitalize}Up" )
      const_get( "PawnDiagonal::PawnDiagonal#{direction.capitalize}Up" ).move( pawn, board )
    else
      raise TypeError, "PawnDiagonal::PawnDiagonal#{direction.capitalize}Up is not a valid constant"
    end
  end
end