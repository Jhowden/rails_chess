require "pawn_diagonal/pawn_diagonal_left_down"
require "pawn_diagonal/pawn_diagonal_right_down"

class PawnDiagonal::PawnDiagonalDown
  def self.move_diagonal( pawn, board, direction )
    if const_defined?( "PawnDiagonal::PawnDiagonal#{direction.capitalize}Down" )
      const_get( "PawnDiagonal::PawnDiagonal#{direction.capitalize}Down" ).move( pawn, board )
    else
      raise TypeError, "PawnDiagonal::PawnDiagonal#{direction.capitalize}Down is not a valid constant"
    end
  end
end