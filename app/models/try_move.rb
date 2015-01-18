require "game_start/check"

module TryMove
  def out_of_check?( king, board, position, enemy_pieces )
    original_position = king.position.dup
    update_the_board( 
      king, 
      board, 
      position, 
      original_position
    )
    !GameStart::Check.king_in_check?( king, enemy_pieces )
  end
  
  def captured_piece?( king, piece, board, position, enemy_pieces )
    piece.board = board
    original_position = piece.position.dup
    update_the_board( 
      piece, 
      board, 
      position, 
      original_position
    )
    !GameStart::Check.king_in_check?( king, enemy_pieces )
  end
  
  def block_piece?( king, piece, board, position, enemy_pieces )
    piece.board = board
    original_position = piece.position.dup
    update_the_board( 
      piece, 
      board, 
      position, 
      original_position
    )
    !GameStart::Check.king_in_check?( king, enemy_pieces )
  end
  
  private
  
  def update_the_board( piece, board, position, original_position )
    piece.update_piece_position( position.file, position.rank )
    board.update_board( piece )
    board.remove_old_position( original_position )
  end
end