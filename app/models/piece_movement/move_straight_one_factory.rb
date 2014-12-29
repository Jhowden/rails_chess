require "piece_movement/move_down_one"
require "piece_movement/move_up_one"

module PieceMovement
  class MoveStraightOneFactory
    def self.create_for( orientation, file, rank, board )
      if const_defined?( "PieceMovement::Move#{orientation.capitalize}One" )
        const_get( "PieceMovement::Move#{orientation.capitalize}One" ).
          move_straight?( file, rank, board )
      else
        raise TypeError, "PieceMovement::Move#{orientation.capitalize}One is not a valid constant"
      end
    end
  end
end