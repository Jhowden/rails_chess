require "find_pieces/find_team_pieces"
module MoveSequence
  class CastleSequence
    TEAM_COLOR_CASTLE_RANK_MAP = {black: 1, white: 8}

    CASTLE_QUEENSIDE_FILE_CONTAINER = ["d", "c", "b"]
    CASTLE_KINGSIDE_FILE_CONTAINER = ["f", "g"]

    QUEENSIDE_ROOK_FILE_INDEX = 0
    KINGSIDE_ROOK_FILE_INDEX = 7
    
    WHITE_ROOK_RANK_INDEX = 0
    BLACK_ROOK_RANK_INDEX = 7
    
    attr_reader :input, :players_info, :board
    
    def initialize( input, players_info )
      @input = input
      @players_info = players_info
      @board = Board.new( BoardJsonParser.
        parse_json_board( players_info.json_board ) )
    end
    
    def valid_move?()
      rook = FindPieces::FindTeamPieces.
        find_kingside_rook( 
          players_info.current_team, 
          board, 
          KINGSIDE_ROOK_FILE_INDEX, 
          WHITE_ROOK_RANK_INDEX )
      king = FindPieces::FindTeamPieces.
        find_king_piece( 
          players_info.current_team, 
          board )
    end
    
    private

    def castle_queenside( king, rank, player, enemy_player )
      if legal_to_castle?( king.move_counter, rook.move_counter ) && queen_side_spaces_unoccupied?( rank )
        kings_starting_position = copy_piece_position king
        attempt_to_castle( king, rook, CASTLE_QUEENSIDE_FILE_CONTAINER.first, CASTLE_QUEENSIDE_FILE_CONTAINER[1],
          rank, kings_starting_position, player, enemy_player )
      end
    end

    def castle_kingside( king, rank, player, enemy_player )
      rook = find_piece_on_board( KINGSIDE_ROOK_FILE, rank )
      if legal_to_castle?( king.move_counter, rook.move_counter ) && king_side_spaces_unoccupied?( rank )
        kings_starting_position = copy_piece_position king
        attempt_to_castle( king, rook, CASTLE_KINGSIDE_FILE_CONTAINER.first, CASTLE_KINGSIDE_FILE_CONTAINER[1],
          rank, kings_starting_position, player, enemy_player )
      else
        piece_already_moved_message
        get_player_move_again( player, enemy_player )
      end
    end

    def legal_to_castle?( king_movement_counter, rook_movement_counter )
      [king_movement_counter, rook_movement_counter].all? { |counter| counter == 0 }
    end

    def attempt_to_castle( king, rook, first_file_move, second_file_move, rank, original_position, player, enemy_player ) # create a CastlingMove class to reduce number or arguments passed in, also do a loop instead of nested conditionals
      update_the_board!( king, first_file_move, rank, copy_piece_position( king ) )
      if check?( player, enemy_player )
        restart_player_turn( king, original_position, copy_piece_position( king ), player, enemy_player )
      else
        update_the_board!( king, second_file_move, rank, copy_piece_position( king ) )
        if check?( player, enemy_player )
          restart_player_turn( king, original_position, copy_piece_position( king ), player, enemy_player )
        else
          update_the_board!( rook, first_file_move, rank, copy_piece_position( rook ) )
          increase_king_and_rook_move_counters( king, rook )
        end
      end
    end

    def convert_file_and_rank_to_position( file, rank )
      Position.new( file, rank )
    end

    def unoccupied_space?( file, rank )
      piece = find_piece_on_board( file, rank )
      piece.respond_to?( :determine_possible_moves ) ? false : true
    end

    def king_side_spaces_unoccupied?( rank )
      CASTLE_KINGSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file, rank )
      }.all? { |boolean| boolean }
    end

    def queen_side_spaces_unoccupied?( rank )
      CASTLE_QUEENSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file, rank ) 
        }.all? { |boolean| boolean }
    end
  end
end