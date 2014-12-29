module PieceMovement
  class MoveUpRightDiagonally
    extend MoveValidations::Validations
    MOVE_MODIFIERS = [1, -1]
    
    def self.move_diagonally?( file, rank, piece, board )
      target_file = file + MOVE_MODIFIERS.first
      target_rank = rank + MOVE_MODIFIERS.last
      
      legal_move?( target_file, target_rank ) && 
        !empty_space?( target_file, target_rank, board ) && 
          different_team?( target_file, target_rank, piece, board )
    end
  end
end