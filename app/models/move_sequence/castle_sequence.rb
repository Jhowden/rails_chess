module MoveSequence
  class CastleSequence
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
      else
        @castle_side = Castle::QueenSide.new( players_info )
      end
    end


    def queen_side_spaces_unoccupied?( rank )
      CASTLE_QUEENSIDE_FILE_CONTAINER.map { |file|
        unoccupied_space?( file, rank ) 
        }.all? { |boolean| boolean }
    end
  end
end