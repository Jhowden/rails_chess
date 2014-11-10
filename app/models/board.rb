class Board
  # include MoveMultipleSpaces
  # include MoveValidations
  # include PawnBoardMoves
  #
  # HORIZONTAL_AND_VERTICAL_SPACE_MOVEMENT = [-1, 1]
  TEAM_COLORS = [:white, :black]
  
  attr_reader :chess_board, :possible_moves
  
  def initialize( chess_board )
    @chess_board = chess_board
    @possible_moves = []
  end
  
  def update_board( piece )
    file = piece.position.file_position_converter
    rank = piece.position.rank_position_converter
    capture_piece( file, rank )
    chess_board[rank][file] = piece
  end
  
  def place_pieces_on_board
    TEAM_COLORS.each do |team|
      pieces = PiecesFactory.new( team ).build.pieces
      pieces.each do |piece|
        update_board( piece )
      end
    end
  end
  
  private 
  
  def capture_piece( file, rank )
    chess_board[rank][file].captured! unless chess_board[rank][file].nil?
  end
  
  # def remove_old_position( piece_position )
  #   file = piece_position.file_position_converter
  #   rank = piece_position.rank_position_converter
  #   chess_board[rank][file] = nil
  # end
  #
  # def find_horizontal_spaces( piece )
  #   clear_possible_moves?
  #
  #   file = piece.position.file_position_converter
  #   rank = piece.position.rank_position_converter
  #
  #   HORIZONTAL_AND_VERTICAL_SPACE_MOVEMENT.each do |horizontal_space|
  #     find_possible_horizontal_spaces( file, rank, piece, horizontal_space )
  #   end
  #
  #   possible_moves
  # end
  #
  # def find_vertical_spaces( piece )
  #   clear_possible_moves?
  #
  #   file = piece.position.file_position_converter
  #   rank = piece.position.rank_position_converter
  #
  #   HORIZONTAL_AND_VERTICAL_SPACE_MOVEMENT.each do |vertical_space|
  #     find_possible_vertical_spaces( file, rank, piece, vertical_space )
  #   end
  #
  #   possible_moves
  # end
  #
  # def find_diagonal_spaces( piece )
  #   clear_possible_moves?
  #
  #   file = piece.position.file_position_converter
  #   rank = piece.position.rank_position_converter
  #
  #   HORIZONTAL_AND_VERTICAL_SPACE_MOVEMENT.each do |vertical_space|
  #     HORIZONTAL_AND_VERTICAL_SPACE_MOVEMENT.each do |horizontal_space|
  #       find_possible_diagonally_spaces( file, rank, piece, vertical_space, horizontal_space )
  #     end
  #   end
  #
  #   possible_moves
  # end
  #
  # def find_knight_spaces( piece )
  #   clear_possible_moves?
  #   find_surrounding_spaces( piece, Knight::KNIGHT_SPACE_MODIFIERS )
  # end
  #
  # def find_king_spaces( piece )
  #   clear_possible_moves?
  #   find_surrounding_spaces( piece, King::KING_SPACE_MODIFIERS )
  # end
  #
  # def convert_to_file_position( index )
  #   Position::FILE_POSITIONS[index]
  # end
  #
  # def convert_to_rank_position( index )
  #   ( index - 8 ).abs
  # end
  #
  # def find_piece( position )
  #   file = position.file_position_converter
  #   rank = position.rank_position_converter
  #   chess_board[rank][file]
  # end
  #
  #
  # private
  #
  # def clear_possible_moves?
  #   possible_moves.clear unless possible_moves.empty?
  # end
end