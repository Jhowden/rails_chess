require "castle_movement_helpers"

module Castle
  class KingSide
    include CastleMovementHelpers
    
    CASTLE_KINGSIDE_FILE_CONTAINER = ["f", "g"]
    
    attr_reader :players_info, :board
    
    def initialize( players_info )
      @players_info = players_info
      @board = Board.new(
        BoardJsonParser.parse_json_board( players_info.json_board ) )
    end

    def can_castle?()
      dummy_board = Board.new(
        BoardJsonParser.parse_json_board( players_info.json_board ) )
      rook = find_castle_rook dummy_board, KINGSIDE_ROOK_FILE_INDEX
      king = find_castle_king dummy_board
      
      legal_to_castle?( rook, king, CASTLE_KINGSIDE_FILE_CONTAINER )
    end

    def response()
      king = find_castle_king board
      rook = find_castle_rook board, KINGSIDE_ROOK_FILE_INDEX
      [
        [king, CASTLE_KINGSIDE_FILE_CONTAINER.last],
        [rook, CASTLE_KINGSIDE_FILE_CONTAINER.first]
      ].each do |piece, updated_file|
        update_piece_on_board piece, updated_file
      end

      return board, "Successful move: Kingside Castle"
    end
    
    private
    
    def update_piece_on_board( piece, update_file )
      starting_piece_position = piece.position.dup
      piece.update_piece_position( Position.new( update_file, piece.position.rank ) )
      board.update_board piece
      board.remove_old_position starting_piece_position
      piece.increase_move_counter!
    end
  end
end