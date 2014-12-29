module PieceMovement
  class MoveUpTwo
    extend MoveValidations::Validations
    
    MOVE_MODIFIERS = [-2, -2]
    
    def self.move_straight?( file, rank, board )
      legal_move?( file, rank + MOVE_MODIFIERS.first ) && empty_space?( file, rank + MOVE_MODIFIERS.last, board )
    end
  end
end