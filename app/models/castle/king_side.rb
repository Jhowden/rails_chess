module Castle
  class KingSide
    CASTLE_KINGSIDE_FILE_CONTAINER = ["f", "g"]
    KINGSIDE_ROOK_RANK = 8
    KINGSIDE_ROOK_FILE_INDEX = 7
    
    attr_reader :players_info, :board
    
    def initialize( players_info )
      @players_info = players_info
      @board = Board.new( 
        BoardJsonParser.parse_json_board( players_info.json_board ) )
    end
    
    def can_castle?()
      rook = Castle.find_rook( players_info.current_team, board, KINGSIDE_ROOK_FILE_INDEX )
      king = Castle.find_king( players_info.current_team, board )
      
      # if kingside_spaces_valid? &&
    end
    
    private
    
    def kingside_spaces_valid?( rook, king )
      if legal_to_castle?( king.move_counter, rook.move_counter ) && king_side_spaces_unoccupied?
        boolean_moves = CASTLE_KINGSIDE_FILE_CONTAINER.map do |rank|
          Castle.valid_move?( king, players_info, board.chess_board, rank )
        end
        boolean_moves.all? { |boolean| boolean }
      else
        false
      end
    end
    
    def king_side_spaces_unoccupied?()
      CASTLE_KINGSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file )
      }.all? { |boolean| boolean }
    end
    
    def unoccupied_space?( file )
      piece = board.
        find_piece_on_board( Position.new( file, KINGSIDE_ROOK_RANK ) )
      piece.determine_possible_moves
    end
    
    def legal_to_castle?( king_movement_counter, rook_movement_counter )
      [king_movement_counter, rook_movement_counter].all? { |counter| counter == 0 }
    end
  end
end