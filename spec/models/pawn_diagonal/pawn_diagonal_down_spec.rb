require "rails_helper"

describe PawnDiagonal::PawnDiagonalDown do
  let( :pawn ) { double( "pawn" ) }
  let( :board ) { double( "board" ) }
  
  before :each do
    stub_const( "PawnDiagonal::PawnDiagonalLeftDown", Class.new )
    allow( PawnDiagonal::PawnDiagonalLeftDown ).to receive( :move )
    
    stub_const( "PawnDiagonal::PawnDiagonalRightDown", Class.new )
    allow( PawnDiagonal::PawnDiagonalRightDown ).to receive( :move )
  end
  
  describe ".move_diagonal" do
    it "calls #move on PawnDiagonal::PawnDiagonalLeftDown" do
      described_class.move_diagonal( pawn, board, :left )
      
      expect( PawnDiagonal::PawnDiagonalLeftDown ).to have_received( :move ).with( pawn, board )
    end
    
    it "calls #move on PawnDiagonal::PawnDiagonalRightDown" do
      described_class.move_diagonal( pawn, board, :right )
      
      expect( PawnDiagonal::PawnDiagonalRightDown ).to have_received( :move ).with( pawn, board )
    end
    
    it "raises a TypeError when the constant is NOT defined" do
      expect{ described_class.
        move_diagonal( pawn, board, :sideways) }.to raise_error TypeError
    end
  end
end