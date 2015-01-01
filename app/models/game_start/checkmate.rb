require "board_json_parser"

module GameStart
  class Checkmate
    attr_reader :json_board, :king, :current_player_pieces, :enemy_pieces,
      :possible_moves
    
    def initialize json_board, king, current_player_pieces, enemy_pieces
      @json_board = json_board
      @king = king
      @current_player_pieces = current_player_pieces
      @enemy_pieces = enemy_pieces
      @possible_moves = []
    end
    
    def find_checkmate_escape_moves
      move_king_to_all_possible_locations( king )
      possible_moves
    end
    
    private
    
    def move_king_to_all_possible_locations king
      original_position = king.position.dup
      king.determine_possible_moves.each do |possible_move|
        target_file, target_rank = possible_move.first, possible_move.last
        attempt_to_move_out_of_check( king, target_file, target_rank, original_position )
        track_possible_moves( king, [target_file, target_rank], original_position ) unless Check.king_in_check?( king, enemy_pieces )
        restore_original_board_on_pieces
      end
    end
    
    def attempt_to_move_out_of_check( king, target_file, target_rank, original_position )
      king.update_piece_position( target_file, target_rank )
      king.board.update_board( king )
      king.board.remove_old_position( original_position )
    end
    
    def track_possible_moves( piece, location, original_position )
      possible_moves << [original_position.file, original_position.rank].
        concat( location )
    end
    
    def restore_original_board_on_pieces
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      pieces = current_player_pieces.concat( enemy_pieces )
      pieces.each { |piece| piece.board = board }
      # insert_board_on_pieces_in_board( pieces, board )
    end
    
    def insert_board_on_pieces_in_board pieces, chess_board
      pieces.each do |piece|
        piece.board.chess_board.each do |row|
          row.each { |location| location.board = chess_board unless location.nil? }
        end
      end
    end
  end
end