module GameStart
  class Check
    def self.king_in_check?( king, enemy_pieces )
      enemy_moves = enemy_pieces.reject { |piece| piece.captured? }.map { |piece| 
        transform_moves( piece.determine_possible_moves ) }.flatten( 1 )
      king.check?( enemy_moves )
    end
    
    private
    
    def self.transform_moves( enemy_moves )
      enemy_moves.map do |move| 
        move.include?( "e.p." ) ? move.last( 4 ) : move.last( 2 )
      end
    end
  end
end