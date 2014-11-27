class GamePieces::ChessPiece
  attr_reader :captured, :position, :board, :team, :possible_moves, :move_counter
  
  def initialize( details, options = {"board" => nil, "move_counter" => 0} )
    new_options = options.merge details
    @position = Position.new( new_options["file"], new_options["rank"] )
    @board = new_options["board"]
    @team = new_options["team"].to_sym
    @captured = new_options["captured"]
    @possible_moves = []
    @move_counter = new_options["move_counter"]
  end
  
  def captured!
    @captured = !captured
  end
  
  def captured?
    captured
  end
  
  def update_piece_position( file, rank )
    position.update_position( file, rank )
  end

  def clear_moves!
    possible_moves.clear
  end

  def increase_move_counter!
    @move_counter += 1
  end
end