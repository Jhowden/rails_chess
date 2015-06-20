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
      castle_side.can_castle?
    end
    
    def response()
      castle_side.response
    end
    
    private
    
    def castle_side()
      return @castle_side if @castle_side
      if input.chess_notation == "0-0"
        @castle_side = Castle::KingSide.new( players_info )
      end
    end


    def queen_side_spaces_unoccupied?( rank )
      CASTLE_QUEENSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file, rank ) 
        }.all? { |boolean| boolean }
    end
  end
end