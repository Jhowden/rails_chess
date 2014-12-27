require "pawn_forward_one/pawn_down_one"
require "pawn_forward_one/pawn_up_one"

class PawnForwardOne::PawnForwardOneFactory
  def self.create_for( orientation, position )
    if const_defined?( "PawnForwardOne::Pawn#{orientation.capitalize}One" )
      const_get( "PawnForwardOne::Pawn#{orientation.capitalize}One" ).
        possible_move( position )
    else
      raise TypeError, "PawnForwardOne::Pawn#{orientation.capitalize}One is not a \
        valid constant"
    end
  end
end