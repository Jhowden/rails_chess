require "rails_helper"

describe PieceMovement::MoveUpLeftDiagonally do
  let( :chess_board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let( :piece ) { double( "piece", team: :white ) }
  let( :board ) { double( "board", chess_board: chess_board ) }
  let( :opposing_piece ) { double( "opposing_piece", team: :black ) }
  let( :friendly_piece ) { double( "friendly_piece", team: :white ) }
  
  describe ".move_diagonally?" do
    it "returns true when a pawn can move diagonally" do
      chess_board[3][2] = opposing_piece
      expect( described_class.
        move_diagonally?( 3, 4, piece, board ) ).to be_truthy
    end
    
    it "returns false when there is no enemy pawn" do
      expect( described_class.
        move_diagonally?( 3, 4, piece, board ) ).to be_falsey
    end
    
    it "returns false when there it is an illegal move" do
      expect( described_class.
        move_diagonally?( 3, 7, piece, board ) ).to be_falsey
    end
    
    it "returns false when the piece is the same team" do
      chess_board[3][2] = friendly_piece
      expect( described_class.
        move_diagonally?( 3, 4, piece, board ) ).to be_falsey
    end
  end
end