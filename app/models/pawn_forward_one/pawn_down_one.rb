class PawnForwardOne::PawnDownOne
  MOVE_MODIFIER = -1
  def self.possible_move( position )
    [position.file, position.rank,
     position.file, position.rank + MOVE_MODIFIER]
  end
end