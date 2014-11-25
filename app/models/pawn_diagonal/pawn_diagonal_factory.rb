require "pawn_diagonal/pawn_diagonal_up"
require "pawn_diagonal/pawn_diagonal_down"

class PawnDiagonal::PawnDiagonalFactory
  def self.create_for( pawn, board, direction, orientation )
    if const_defined?( "PawnDiagonal::PawnDiagonal#{orientation.capitalize}" )
      const_get( "PawnDiagonal::PawnDiagonal#{orientation.capitalize}" ).move_diagonal( pawn, board, direction )
    else
      raise TypeError, "PawnDiagonal::PawnDiagonal#{orientation.capitalize} is not a valid constant"
    end
  end
end