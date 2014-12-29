require "rails_helper"

describe PieceMovement::MoveStraightOneFactory do
  let( :board ) { double( "board" ) }
  
  before :each do
    stub_const( "PieceMovement::MoveUpOne", Class.new )
    allow( PieceMovement::MoveUpOne ).to receive( :move_straight? )

    stub_const( "PieceMovement::MoveDownOne", Class.new )
    allow( PieceMovement::MoveDownOne ).to receive( :move_straight? )
  end
  
  describe ".create_for" do
    it "calls .move_straight? on PieceMovement::MoveUpOne" do
      described_class.create_for( :up, 3, 4, board )
      expect( PieceMovement::MoveUpOne ).to have_received( :move_straight? ).
        with( 3, 4, board )
    end
    
    it "calls .move_straight? on PieceMovement::MoveDownOne" do
      described_class.create_for( :down, 3, 4, board )
      expect( PieceMovement::MoveDownOne ).to have_received( :move_straight? ).
        with( 3, 4, board )
    end
    
    it "raises an error when the orientation is incorrect" do
      expect{ described_class.
        create_for( :sideways, 3, 4, board ) }.to raise_error TypeError
    end
  end
end