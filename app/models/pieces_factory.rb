class PiecesFactory
  include StartingPositions::RookStartingPositions
  include StartingPositions::BishopStartingPositions
  include StartingPositions::KnightStartingPositions

  attr_reader :pieces, :board, :team, :en_passant

  def initialize( team )
    @team = team
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
        pieces << GamePieces::Pawn.new( { file: Position::FILE_POSITIONS[file], 
          rank: 7, team: team, orientation: :down, 
          captured: false, capture_through_en_passant: true } )
      else
        pieces << GamePieces::Pawn.new( {file: Position::FILE_POSITIONS[file], 
          rank: 2, team: team, orientation: :up, 
          captured: false, capture_through_en_passant: true } )
      end
    end
  end

  def create_rooks
    if team == :white
      StartingPositions::RookStartingPositions::WHITE_ROOK_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Rook.new( { file: file, rank: rank, captured: false, team: team } )
      end
    else
      StartingPositions::RookStartingPositions::BLACK_ROOK_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Rook.new( { file: file, rank: rank, captured: false, team: team } )
      end
    end
  end

  def create_bishops
    if team == :white
      StartingPositions::BishopStartingPositions::WHITE_BISHOP_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Bishop.new( { file: file, rank: rank, captured: false, team: team } )
      end
    else
      StartingPositions::BishopStartingPositions::BLACK_BISHOP_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Bishop.new( { file: file, rank: rank, captured: false, team: team } )
      end
    end
  end

  def create_knights
    if team == :white
      StartingPositions::KnightStartingPositions::WHITE_KNIGHT_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Knight.new( { file: file, rank: rank, captured: false, team: team } )
      end
    else
      StartingPositions::KnightStartingPositions::BLACK_KNIGHT_STARTING_POSITIONS.each do |file, rank|
        pieces << GamePieces::Knight.new( { file: file, rank: rank, captured: false, team: team } )
      end
    end
  end

  def create_queen
    if team == :white
      pieces << GamePieces::Queen.new( { file: "d", rank: 8, captured: false, team: team } )
    else
      pieces << GamePieces::Queen.new( { file: "d", rank: 1, captured: false, team: team } )
    end
  end

  def create_king
    if team == :white
      pieces << GamePieces::King.new( { file: "e", rank: 8, captured: false, checkmate: false, team: team } )
    else
      pieces << GamePieces::King.new( { file: "e", rank: 1, captured: false, checkmate: false, team: team} )
    end
  end
end