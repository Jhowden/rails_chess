require "rails_helper"

describe PieceMovement::MoveStraightTwoFactory do
  let( :board ) { double( "board" ) }
  
  before :each do
    stub_const( "PieceMovement::MoveUpTwo", Class.new )
    allow( PieceMovement::MoveUpTwo ).to receive( :move_straight? )

    stub_const( "PieceMovement::MoveDownTwo", Class.new )
    allow( PieceMovement::MoveDownTwo ).to receive( :move_straight? )
  end
  
  describe ".create_for" do
    it "calls .move_straight? on PieceMovement::MoveUpTwo" do
      described_class.create_for( :up, 3, 4, board )
      expect( PieceMovement::MoveUpTwo ).to have_received( :move_straight? ).
        with( 3, 4, board )
    end
    
    it "calls .move_straight? on PieceMovement::MoveDownTwo" do
      described_class.create_for( :down, 3, 4, board )
      expect( PieceMovement::MoveDownTwo ).to have_received( :move_straight? ).
        with( 3, 4, board )
    end
    
    it "raises an error when the orientation is incorrect" do
      expect{ described_class.
        create_for( :sideways, 3, 4, board ) }.to raise_error TypeError
    end
  end
end