require "pawn_forward_one/pawn_down_one"
require "pawn_forward_one/pawn_up_one"

class PawnForwardOne::PawnForwardOneFactory
  def self.create_for( orientation, position )
    if const_defined?( "PawnForwardOne::Pawn#{orientation.to_s.capitalize}One" )
      const_get(       "PawnForwardOne::Pawn#{orientation.to_s.capitalize}One" ).possible_move( position )
    end
  end
end