module GameStart
  class Check
    def self.king_in_check?( king, enemy_pieces )
      enemy_moves = enemy_pieces.map { |piece| 
        piece.determine_possible_moves }.flatten( 1 )
      king.check?( enemy_moves )
    end
  end
end