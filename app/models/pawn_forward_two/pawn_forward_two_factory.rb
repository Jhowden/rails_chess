require "pawn_forward_two/pawn_down_two"
require "pawn_forward_two/pawn_up_two"

class PawnForwardTwo::PawnForwardTwoFactory
  def self.create_for( orientation, position )
    if const_defined?( "PawnForwardTwo::Pawn#{orientation.to_s.capitalize}Two" )
      const_get(       "PawnForwardTwo::Pawn#{orientation.to_s.capitalize}Two" ).possible_move( position )
    end
  end
end