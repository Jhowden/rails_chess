module TransformPieceMoves
  def self.transform_moves( enemy_moves )
    enemy_moves.map do |move| 
      move.include?( "e.p." ) ? move.last( 3 ) : move.last( 2 )
    end
  end
end