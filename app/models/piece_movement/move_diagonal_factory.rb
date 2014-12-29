require "piece_movement/move_up_left_diagonally"
require "piece_movement/move_up_right_diagonally"
require "piece_movement/move_down_left_diagonally"
require "piece_movement/move_down_right_diagonally"

module PieceMovement
  class MoveDiagonalFactory
    def self.create_for( orientation, direction, file, rank, piece, board )
      if const_defined?( "PieceMovement::Move#{orientation.capitalize}#{direction.capitalize}Diagonally" )
        const_get( "PieceMovement::Move#{orientation.capitalize}#{direction.capitalize}Diagonally" )
          .move_diagonally?( file, rank, piece, board )
      else
        raise TypeError, 
          "PieceMovement::Move#{orientation.capitalize}#{direction.capitalize}Diagonally is not a valid constant"
      end
    end
  end
end