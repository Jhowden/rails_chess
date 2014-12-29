require "rails_helper"

describe PieceMovement::MoveDownTwo do
  let( :board ) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  
  describe ".move_straight?" do
    it "returns true when a pawn can move forward" do
      expect( described_class.move_straight?( 2, 4, board ) ).to be_truthy
    end
    
    it "returns false when a pawn can NOT move forward" do
      expect( described_class.move_straight?( 7, 7, board ) ).to be_falsey
    end
  end
end