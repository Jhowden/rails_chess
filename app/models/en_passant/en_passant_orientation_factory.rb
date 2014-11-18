require "en_passant/down_en_passant_moves"
require "en_passant/up_en_passant_moves"

class EnPassant::EnPassantOrientationFactory
  def self.for_orientation( pawn )
    if Object.const_defined?( "EnPassant::#{pawn.orientation.to_s.capitalize}EnPassantMoves" )
      const_get( "EnPassant::#{pawn.orientation.to_s.capitalize}EnPassantMoves" ).new( pawn )
    else
      raise TypeError, "EnPassant::#{pawn.orientation.to_s.capitalize}EnPassantMoves is not a valid constant."
    end
  end
end