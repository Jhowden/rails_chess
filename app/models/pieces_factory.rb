class PiecesFactory
  include StartingPositions::RookStartingPositions
  include StartingPositions::BishopStartingPositions
  include StartingPositions::KnightStartingPositions

  attr_reader :pieces, :board, :team, :en_passant

  def initialize( board, team, en_passant )
    @board = board
    @team = team
    @en_passant = en_passant
    @pieces = []
  end
  
  def build
    create_pawns
    create_rooks
    create_bishops
    create_knights
    create_queen
    create_king
  end
  
  private

  def create_pawns
    8.times do |file|
      if team == :white
        pieces << GamePieces::Pawn.new( Position::FILE_POSITIONS[file], 7, team, board, :down, en_passant )
      else
        pieces << GamePieces::Pawn.new( Position::FILE_POSITIONS[file], 2, team, board, :up, en_passant )
      end
    end
  end

  def create_rooks
    if team == :white
      StartingPositions::RookStartingPositions::WHITE_ROOK_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Rook.new( file, rank, team, board )
      end
    else
      StartingPositions::RookStartingPositions::BLACK_ROOK_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Rook.new( file, rank, team, board )
      end
    end
  end

  def create_bishops
    if team == :white
      StartingPositions::BishopStartingPositions::WHITE_BISHOP_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Bishop.new( file, rank, team, board )
      end
    else
      StartingPositions::BishopStartingPositions::BLACK_BISHOP_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Bishop.new( file, rank, team, board )
      end
    end
  end

  def create_knights
    if team == :white
      StartingPositions::KnightStartingPositions::WHITE_KNIGHT_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Knight.new( file, rank, team, board )
      end
    else
      StartingPositions::KnightStartingPositions::BLACK_KNIGHT_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Knight.new( file, rank, team, board )
      end
    end
  end

  def create_queen
    if team == :white
      pieces << GamePieces::Queen.new( "d", 8, team, board )
    else
      pieces << GamePieces::Queen.new( "d", 1, team, board )
    end
  end

  def create_king
    if team == :white
      pieces << GamePieces::King.new( "e", 8, team, board )
    else
      pieces << GamePieces::King.new( "e", 1, team, board )
    end
  end
end