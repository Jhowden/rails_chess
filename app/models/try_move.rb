require "game_start/check"

module TryMove
  def out_of_check?( king, board, location, enemy_pieces )
    old_position = king.position.dup
    new_position = Position.new( location.first, location.last )
    king.update_piece_position( new_position.file, new_position.rank )
    board.update_board( king )
    board.remove_old_position( old_position )
    !GameStart::Check.king_in_check?( king, enemy_pieces )
  end
end