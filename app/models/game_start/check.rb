require "transform_piece_moves"

module GameStart
  class Check
    def self.king_in_check?( king, enemy_pieces )
      enemy_moves = enemy_pieces.reject { |piece| piece.captured? }.map { |piece| 
        TransformPieceMoves.
          transform_moves( piece.determine_possible_moves ) }.flatten( 1 )
      king.check?( enemy_moves )
    end
  end
end