class GamePieces::Queen < GamePieces::ChessPiece
  attr_reader :board_marker

  def initialize( details )
    super
    @board_marker = determine_board_marker
  end

  def determine_possible_moves
    clear_moves!
    
    horizontal_moves = board.find_horizontal_spaces( self ).
      map { |location| starting_location + location }
    vertical_moves = board.find_vertical_spaces( self ).
      map { |location| starting_location + location }
    diagonal_moves = board.find_diagonal_spaces( self ).
      map { |location| starting_location + location }

    possible_moves.concat horizontal_moves
    possible_moves.concat vertical_moves
    possible_moves.concat diagonal_moves

    possible_moves
  end

  def determine_board_marker
    team == :white ? "♕" : "♛"
  end
end