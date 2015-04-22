class PawnForwardTwo::PawnDownTwo
  MOVE_MODIFIER = -2
  def self.possible_move( position )
    [position.file, position.rank,
     position.file, position.rank + MOVE_MODIFIER]
  end
end