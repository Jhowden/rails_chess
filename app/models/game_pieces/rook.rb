class GamePieces::Rook < GamePieces::ChessPiece
  attr_reader :board_marker

  def initialize( details )
    super
    @board_marker = determine_board_marker
  end
  
  def determine_possible_moves
    clear_moves!
    
    horizontal_spaces = board.find_horizontal_spaces( self ).
      map { |location| starting_location + location }
    vertical_spaces = board.find_vertical_spaces( self ).
      map { |location| starting_location + location }
    possible_moves.concat horizontal_spaces
    possible_moves.concat vertical_spaces
    
    possible_moves
  end

  def determine_board_marker
    team == :white ? "♖" : "♜"
  end
end