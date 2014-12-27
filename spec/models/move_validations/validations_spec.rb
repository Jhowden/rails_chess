require "rails_helper"

describe MoveValidations::Validations do 
  let( :piece ) { double( position: Position.new( "b", 8 ), team: :black ) }
  let( :piece2 ) { double( position: Position.new( "c", 8 ), team: :black ) }
  let( :piece3 ) { double( position: Position.new( "d", 8 ), team: :white ) }
  let( :board ) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  
  subject { Board.new( board.chess_board ).extend( described_class ) }
  
  describe "#legal_move?" do
    it "checks if an input is a legal move" do
      expect( subject.legal_move?( 4, 6 ) ).to be_truthy
      expect( subject.legal_move?( 5, 8 ) ).to be_falsey
      expect( subject.legal_move?( 8, 0 ) ).to be_falsey
    end
  end
  
  describe "#empty_space?" do
    it "checks to see if a position is empty" do
      subject.chess_board[0][1] = piece
      expect( subject.empty_space?( 2, 6, board ) ).to be_truthy
      expect( subject.empty_space?( 1, 0, board ) ).to be_falsey
    end
  end
  
  describe "#different_team?" do
    it "checks to see if an encountered piece is of the same team" do
      subject.chess_board[0][1] = piece
      expect( subject.different_team?( 1, 0, piece2, board ) ).to be_falsey
      expect( subject.different_team?( 1, 0, piece3, board ) ).to be_truthy
    end
  end
  
  describe "#valid_location?" do
    it "checks to see if a location is valid" do
      subject.chess_board[0][1] = piece
      expect( subject.
        valid_location?( 1, 0, piece2, board ) ).to be_falsey
      expect( subject.
        valid_location?( 1, 0, piece3, board ) ).to be_truthy
      expect( subject.
        valid_location?( 2, 5, piece, board ) ).to be_truthy
    end
  end
end