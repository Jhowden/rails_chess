module PieceMovement
  module PawnMovement
    
    def move_straight_one_space?( piece )
      file, rank = find_piece_location piece.position
      
      MoveStraightOneFactory.
        create_for( piece.orientation, file, rank, piece.board )
    end
    
    def move_straight_two_spaces?( piece )
      file, rank = find_piece_location piece.position
      
      if move_two_spaces?( piece.orientation, piece )
        MoveStraightTwoFactory.
          create_for( piece.orientation, file, rank, piece.board )
      else
        false
      end
    end
    
    def move_forward_diagonally?( piece, direction )
      file, rank = find_piece_location piece.position
      
      MoveDiagonalFactory.
        create_for( piece.orientation, direction, file, rank, piece, piece.board )
    end
    
    private
    
    def move_two_spaces?( orientation, piece )
      piece.orientation == orientation && 
        move_straight_one_space?( piece ) && 
        pawn_first_move?( piece.move_counter )
    end
    
    def pawn_first_move?( piece_move_counter )
      piece_move_counter == 0
    end
  end
end