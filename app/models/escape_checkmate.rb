require "game_start/check"

module EscapeCheckmate
  def king_escaped?( king, board, position, enemy_pieces )
    original_position = king.position.dup
    update_the_board( 
      king, 
      board, 
      position, 
      original_position
    )
    out_of_check?( king, enemy_pieces )
  end
  
  def king_protected?( king, piece, board, position, enemy_pieces )
    piece.board = board
    original_position = piece.position.dup
    update_the_board( 
      piece, 
      board, 
      position, 
      original_position
    )
    out_of_check?( king, enemy_pieces )
  end
  
  private
  
  def out_of_check?( king, enemy_pieces )
    !GameStart::Check.king_in_check?( king, enemy_pieces )
  end
  
  def update_the_board( piece, board, position, original_position )
    piece.update_piece_position( position )
    board.update_board( piece )
    board.remove_old_position( original_position )
  end
end