class PawnDiagonal::PawnDiagonalMovement
  def self.possible_move( pawn, navigation, rank_modifier)
    [
      find_new_file_position( pawn, navigation ),
      find_new_rank_position( pawn, rank_modifier ) 
    ]
  end
  
  private
  
  def self.find_new_file_position( pawn, navigation )
    pawn.new_file_position( navigation )
  end
  
  def self.find_new_rank_position( pawn, rank_modifier )
    pawn.position.rank + rank_modifier
  end
end