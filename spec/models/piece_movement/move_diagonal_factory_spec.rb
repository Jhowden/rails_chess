require "rails_helper"

describe PieceMovement::MoveDiagonalFactory do
  let( :board ) { double( "board" ) }
  let( :piece ) { double( "piece" ) }
  
  before :each do
    stub_const( "PieceMovement::MoveUpLeftDiagonally", Class.new )
    allow( PieceMovement::MoveUpLeftDiagonally ).to receive( :move_diagonally? )
    
    stub_const( "PieceMovement::MoveUpRightDiagonally", Class.new )
    allow( PieceMovement::MoveUpRightDiagonally ).to receive( :move_diagonally? )
    
    stub_const( "PieceMovement::MoveDownLeftDiagonally", Class.new )
    allow( PieceMovement::MoveDownLeftDiagonally ).to receive( :move_diagonally? )
    
    stub_const( "PieceMovement::MoveDownRightDiagonally", Class.new )
    allow( PieceMovement::MoveDownRightDiagonally ).to receive( :move_diagonally? )
  end
  
  describe ".create_for" do
    it "calls .move_diagonally? a MoveUpLeftDiagonally object" do
      described_class.create_for( :up, :left, 4, 3, piece, board )
      
      expect( PieceMovement::MoveUpLeftDiagonally ).to have_received( :move_diagonally? ).
        with( 4, 3, piece, board )
    end
    
    it "calls .move_diagonally? a MoveUpRightDiagonally object" do
      described_class.create_for( :up, :right, 4, 3, piece, board )
      
      expect( PieceMovement::MoveUpRightDiagonally ).to have_received( :move_diagonally? ).
        with( 4, 3, piece, board )
    end
    
    it "calls .move_diagonally? a MoveDownRightDiagonally object" do
      described_class.create_for( :down, :right, 4, 3, piece, board )
      
      expect( PieceMovement::MoveDownRightDiagonally ).to have_received( :move_diagonally? ).
        with( 4, 3, piece, board )
    end
    
    it "calls .move_diagonally? a MoveDownLeftDiagonally object" do
      described_class.create_for( :down, :left, 4, 3, piece, board )
      
      expect( PieceMovement::MoveDownLeftDiagonally ).to have_received( :move_diagonally? ).
        with( 4, 3, piece, board )
    end
    
    it "raises a TypeError when the Constant does not exist" do
      expect{ described_class.
        create_for( :north, :left, 4, 3, piece, board ) }.to raise_error TypeError
    end
  end
end