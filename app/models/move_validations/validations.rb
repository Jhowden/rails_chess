module MoveValidations
  module Validations
    def legal_move?( file_position, rank_position )
      check_value?( file_position ) && check_value?( rank_position ) ? true : false
    end
    
    def empty_space?( file, rank, board )
      board.chess_board[rank][file].nil?
    end
    
    def different_team?( file, rank, piece, board )
      board.chess_board[rank][file].team != piece.team
    end
    
    def valid_location?( file, rank, piece, board )
      empty_space?( file, rank, board ) || different_team?( file, rank, piece, board )
    end
    
    private
    
    def check_value?( value )
      value <= 7 && value >= 0
    end
  end
end