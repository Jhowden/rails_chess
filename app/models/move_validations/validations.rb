module MoveValidations
  module Validations
    def legal_move?( file_position, rank_position )
      check_value?( file_position ) && check_value?( rank_position ) ? true : false
    end
    
    def empty_space?( file, rank )
      chess_board[rank][file].nil?
    end
    
    def different_team?( file, rank, piece )
      chess_board[rank][file].team != piece.team
    end
    
    def valid_location?( file, rank, piece )
      empty_space?( file, rank ) || different_team?( file, rank, piece )
    end
    
    private
    
    def check_value?( value )
      value <= 7 && value >= 0
    end
  end
end