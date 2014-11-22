require "en_passant_commands"
require "file_checker_factory"
require "pawn_forward_one/pawn_forward_one_factory"
require "pawn_forward_two/pawn_forward_two_factory"

class GamePieces::Pawn < GamePieces::ChessPiece
  include EnPassantCommands
  
  attr_reader :orientation, :board_marker, :starting_location, :en_passant, :capture_through_en_passant
  
  def initialize( details )
    super( details )
    @orientation = details[:orientation]
    @capture_through_en_passant = details[:capture_through_en_passant]
    @board_marker = determine_board_marker
  end
  
  def determine_possible_moves
    clear_moves!
    
    possible_moves << piece_move_forward_one_space
    possible_moves << piece_move_forward_two_spaces
    possible_moves << piece_move_forward_diagonally( :left )
    possible_moves << piece_move_forward_diagonally( :right )
    possible_moves << EnPassantCommands.capture_pawn_en_passant!( self, :previous ) if EnPassantCommands.can_en_passant?( self, :previous )
    possible_moves << EnPassantCommands.capture_pawn_en_passant!( self, :next ) if EnPassantCommands.can_en_passant?( self, :next )
    
    possible_moves.compact!
  end

  def determine_board_marker
    team == :white ? "♙" : "♟"
  end
  
  def new_file_position( navigation )
    index = FileCheckerFactory.create_for( position, navigation )
    Position::FILE_POSITIONS[index]
  end
  
  def update_en_passant_status!
    @capture_through_en_passant = false
  end
  
  def can_be_captured_en_passant?
    capture_through_en_passant
  end
  
  private
  
  def piece_move_forward_one_space
    if board.move_straight_one_space?( self )
      PawnForwardOne::PawnForwardOneFactory.create_for( orientation, position )
    end
  end

  def piece_move_forward_two_spaces
    if board.move_straight_two_spaces?( self )
      PawnForwardTwo::PawnForwardTwoFactory.create_for( orientation, position )
    end
  end
  
  def piece_move_forward_diagonally( direction )
    PawnDiagonalFactory.create_for( self, direction, orientation )
  end
end

class PawnDiagonalFactory
  def self.create_for( pawn, direction, orientation )
    if const_defined?( "PawnDiagonal#{orientation.capitalize}" )
      const_get( "PawnDiagonal#{orientation.capitalize}" ).move_diagonal( pawn, direction )
    end
  end
end

class PawnDiagonalUp
  def self.move_diagonal( pawn, direction )
    if direction == :left && pawn.board.move_forward_diagonally?( pawn, :left )
      [pawn.new_file_position( :previous ), pawn.position.rank + 1]
    elsif direction == :right && pawn.board.move_forward_diagonally?( pawn, :right )
      [pawn.new_file_position( :next ), pawn.position.rank + 1]
    end
  end
end

class PawnDiagonalDown
  def self.move_diagonal( pawn, direction )
    if direction == :left && pawn.board.move_forward_diagonally?( pawn, :left )
      [pawn.new_file_position( :next ), pawn.position.rank - 1]
    elsif direction == :right && pawn.board.move_forward_diagonally?( pawn, :right )
      [pawn.new_file_position( :previous ), pawn.position.rank - 1]
    end
  end
end