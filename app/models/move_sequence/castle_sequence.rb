require "find_pieces/find_team_pieces"

module MoveSequence
  class CastleSequence
    TEAM_COLOR_CASTLE_RANK_MAP = {black: 1, white: 8}

    CASTLE_QUEENSIDE_FILE_CONTAINER = ["d", "c", "b"]
    CASTLE_KINGSIDE_FILE_CONTAINER = ["f", "g"]

    KINGSIDE_ROOK_RANK = 8

    QUEENSIDE_ROOK_FILE_INDEX = 0
    KINGSIDE_ROOK_FILE_INDEX = 7
    
    WHITE_ROOK_RANK_INDEX = 0
    BLACK_ROOK_RANK_INDEX = 7
    
    attr_reader :input, :players_info, :board
    
    def initialize( input, players_info )
      @input = input
      @players_info = players_info
    end
    
    def valid_move?()
      castle_side = castle
      if castle_side.can_castle?
      end
    end
    
    private
    
    def castle()
      if input.chess_notation == "0-0"
        Castle::KingSide.new( players_info )
      end
    end
    
    
    
    def attempt_to_castle( king, rook )
      original_king_positon = king.position.dup
      king.update_piece_position target_position
      board.update_board king
      board.remove_old_position original_king_positon
    end

    
    
    
    
    
    
    

    def castle_queenside( king, rank, player, enemy_player )
      if legal_to_castle?( king.move_counter, rook.move_counter ) && queen_side_spaces_unoccupied?( rank )
        kings_starting_position = copy_piece_position king
        attempt_to_castle( king, rook, CASTLE_QUEENSIDE_FILE_CONTAINER.first, CASTLE_QUEENSIDE_FILE_CONTAINER[1],
          rank, kings_starting_position, player, enemy_player )
      end
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

    def queen_side_spaces_unoccupied?( rank )
      CASTLE_QUEENSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file, rank ) 
        }.all? { |boolean| boolean }
    end
  end
end