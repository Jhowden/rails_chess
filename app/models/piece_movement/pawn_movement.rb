module PieceMovement
  module PawnMovement
    UP_LEFT_MOVE_MODIFIERS = [-1, -1]
    UP_RIGHT_MOVE_MODIFIERS = [1, -1]
    DOWN_LEFT_MOVE_MODIFIERS = [1, 1]
    DOWN_RIGHT_MOVE_MODIFIERS = [-1, 1]
    
    def move_straight_one_space?( piece )
      file, rank = find_piece_location piece.position
      
      PieceMovement::MoveStraightOneFactory.
        create_for( piece.orientation, file, rank, piece.board )
    end
    
    def move_straight_two_spaces?( piece )
      file, rank = find_piece_location piece.position
      
      if move_two_spaces?( piece.orientation, piece )
        PieceMovement::MoveStraightTwoFactory.
          create_for( piece.orientation, file, rank, piece.board )
      else
        false
      end
    end
    
    def move_forward_diagonally?( piece, direction )
      file, rank = find_piece_location piece.position
    
      if piece.orientation == :up
        if direction == :left
          move_diagonally?( file, rank, UP_LEFT_MOVE_MODIFIERS, piece, piece.board  )
        else
          move_diagonally?( file, rank, UP_RIGHT_MOVE_MODIFIERS, piece, piece.board  )
        end
      else
        if direction == :left
          move_diagonally?( file, rank, DOWN_LEFT_MOVE_MODIFIERS, piece, piece.board  )
        else
          move_diagonally?( file, rank, DOWN_RIGHT_MOVE_MODIFIERS, piece, piece.board  )
        end
      end
    end
    
    private
    
    def move_straight?( file, rank, move_modifier, board )
      legal_move?( file, rank + move_modifier.first ) && empty_space?( file, rank + move_modifier.last, board )
    end
    
    def move_two_spaces?( orientation, piece )
      piece.orientation == orientation && move_straight_one_space?( piece ) && 
        pawn_first_move?( piece.move_counter )
    end
    
    def pawn_first_move?( piece_move_counter )
      piece_move_counter == 0
    end
    
    def move_diagonally?( file, rank, move_modifier, piece, board )
      legal_move?( file + move_modifier.first, rank + move_modifier.last ) && 
        !empty_space?( file + move_modifier.first, rank + move_modifier.last, board ) && 
          different_team?( file + move_modifier.first, rank + move_modifier.last, piece, board )
    end
  end
end