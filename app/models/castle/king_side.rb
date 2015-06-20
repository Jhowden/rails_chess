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
      dummy_board = Board.new(
                  BoardJsonParser.parse_json_board( players_info.json_board ) )
      rook = find_rook dummy_board
      king = find_king dummy_board
      
      kingside_spaces_valid?( rook, king )
    end

    def response()
      king = find_king board
      rook = find_rook board
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

    def find_king( board )
      Castle.find_king( players_info.current_team, board )
    end

    def find_rook( board )
      Castle.find_rook( players_info.current_team, board, KINGSIDE_ROOK_FILE_INDEX )
    end

    def kingside_spaces_valid?( rook, king )
      if legal_to_castle?( king.move_counter, rook.move_counter ) && !king_side_spaces_unoccupied?
        boolean_moves = CASTLE_KINGSIDE_FILE_CONTAINER.map do |file|
          dummy_board = Board.new(
                  BoardJsonParser.parse_json_board( players_info.json_board ) )
          Castle.valid_move?( king, players_info, dummy_board, file )
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