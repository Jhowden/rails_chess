require "piece_movement/move_down_two"
require "piece_movement/move_up_two"

module PieceMovement
  class MoveStraightTwoFactory
    def self.create_for( orientation, file, rank, board )
      if const_defined?( "PieceMovement::Move#{orientation.capitalize}Two" )
        const_get( "PieceMovement::Move#{orientation.capitalize}Two" ).
          move_straight?( file, rank, board )
      else
        raise TypeError, "PieceMovement::Move#{orientation.capitalize}Two is not a valid constant"
      end
    end
  end
end