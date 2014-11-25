require "rails_helper"

describe PawnDiagonal::PawnDiagonalUp do
  let( :pawn ) { double( "pawn" ) }
  let( :board ) { double( "board" ) }
  
  before :each do
    stub_const( "PawnDiagonal::PawnDiagonalLeftUp", Class.new )
    allow( PawnDiagonal::PawnDiagonalLeftUp ).to receive( :move )
    
    stub_const( "PawnDiagonal::PawnDiagonalRightUp", Class.new )
    allow( PawnDiagonal::PawnDiagonalRightUp ).to receive( :move )
  end
  
  describe ".move_diagonal" do
    it "calls #move on PawnDiagonal::PawnDiagonalLeftUp" do
      described_class.move_diagonal( pawn, board, :left )
      
      expect( PawnDiagonal::PawnDiagonalLeftUp ).to have_received( :move ).with( pawn, board )
    end
    
    it "calls #move on PawnDiagonal::PawnDiagonalRightUp" do
      described_class.move_diagonal( pawn, board, :right )
      
      expect( PawnDiagonal::PawnDiagonalRightUp ).to have_received( :move ).with( pawn, board )
    end
    
    it "raises a TypeError when the constant is NOT defined" do
      expect{ described_class.
        move_diagonal( pawn, board, :sideways) }.to raise_error TypeError
    end
  end
end