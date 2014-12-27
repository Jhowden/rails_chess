class Board
  include MoveValidations::Validations
  include PieceMovement::VerticalMovement, PieceMovement::HorizontalMovement, 
    PieceMovement::DiagonalMovement, PieceMovement::SurroundingMovement
  # include PawnBoardMoves
  #
  MOVEMENT_COUNTERS = [-1, 1]
  TEAM_COLORS = [:white, :black]
  
  attr_reader :chess_board, :possible_moves
  
  def initialize( chess_board )
    @chess_board = chess_board
    @possible_moves = []
  end
  
  def update_board( piece )
    file, rank = find_piece_location( piece.position )
    capture_piece( file, rank )
    chess_board[rank][file] = piece
  end
  
  def place_pieces_on_board
    TEAM_COLORS.each do |team|
      pieces = PiecesFactory.new( team ).build
      pieces.each do |piece|
        update_board( piece )
      end
    end
  end
  
  def find_piece_on_board( piece_position )
    piece = find_piece( piece_position )
    piece || NullObject::NullPiece.new
  end
  
  def remove_old_position( piece_position )
    file, rank = find_piece_location( piece_position )
    chess_board[rank][file] = nil
  end
  
  def convert_to_file_position( index )
    Position::FILE_POSITIONS[index]
  end
  
  def convert_to_rank_position( index )
    ( index - 8 ).abs
  end
  
  def find_vertical_spaces( piece )
    clear_possible_moves!
    
    file,rank = find_piece_location piece.position

    MOVEMENT_COUNTERS.each do |vertical_counter|
      possible_moves.concat( 
        find_possible_vertical_spaces( file, rank, piece, vertical_counter ) 
      )
    end

    possible_moves
  end
  
  def find_horizontal_spaces( piece )
    clear_possible_moves!
    
    file,rank = find_piece_location piece.position

    MOVEMENT_COUNTERS.each do |horizontal_space|
      possible_moves.concat(
        find_possible_horizontal_spaces( file, rank, piece, horizontal_space )
      )
    end

    possible_moves
  end
  
  def find_diagonal_spaces( piece )
    clear_possible_moves!
    
    file,rank = find_piece_location piece.position

    MOVEMENT_COUNTERS.each do |vertical_space|
      MOVEMENT_COUNTERS.each do |horizontal_space|
        possible_moves.concat( 
          find_possible_diagonally_spaces( file, rank, piece, vertical_space, horizontal_space )
        )
      end
    end

    possible_moves
  end
  
  def find_knight_spaces( piece )
    clear_possible_moves!
    
    file,rank = find_piece_location piece.position
    
    find_surrounding_spaces( file, rank, piece, GamePieces::Knight::KNIGHT_SPACE_MODIFIERS )
  end
  
  def find_king_spaces( piece )
    clear_possible_moves!
    
    file,rank = find_piece_location piece.position
    
    find_surrounding_spaces( file, rank, piece, GamePieces::King::KING_SPACE_MODIFIERS )
  end
  
  private 
  
  def capture_piece( file, rank )
    chess_board[rank][file].captured! unless chess_board[rank][file].nil?
  end
  
  def find_piece( position )
    file, rank = find_piece_location( position )
    chess_board[rank][file]
  end
  
  def clear_possible_moves!
    possible_moves.clear unless possible_moves.empty?
  end
  
  def find_piece_location( piece_position )
    [
      piece_position.file_position_converter,
      piece_position.rank_position_converter
    ]
  end
end