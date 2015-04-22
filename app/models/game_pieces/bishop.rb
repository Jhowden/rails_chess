class GamePieces::Bishop < GamePieces::ChessPiece
  attr_reader :board_marker

  def initialize( details )
    super
    @board_marker = determine_board_marker
  end
  
  def determine_possible_moves
    clear_moves!

    moves = board.find_diagonal_spaces( self ).
      map { |location| starting_location + location }
    possible_moves.concat moves
    
    possible_moves
  end

  def determine_board_marker
    team == :white ? "♗" : "♝"
  end
end