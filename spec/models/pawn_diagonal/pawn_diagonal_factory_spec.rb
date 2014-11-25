require "rails_helper"

describe PawnDiagonal::PawnDiagonalFactory do
  let( :pawn ) { double( "pawn" ) }
  let( :board ) { double( "board" ) }
  
  before :each do
    stub_const( "PawnDiagonal::PawnDiagonalUp", Class.new )
    allow( PawnDiagonal::PawnDiagonalUp ).to receive( :move_diagonal )
    
    stub_const( "PawnDiagonal::PawnDiagonalDown", Class.new )
    allow( PawnDiagonal::PawnDiagonalDown ).to receive( :move_diagonal )
  end
  
  describe ".create_for" do
    it "creates a PawnDiagonal::PawnDiagonalUp object" do
      described_class.create_for( pawn, board, :left, :up )
      
      expect( PawnDiagonal::PawnDiagonalUp ).to have_received( :move_diagonal ).
        with( pawn, board, :left )
    end
    
    it "creates a PawnDiagonal::PawnDiagonalDown object" do
      described_class.create_for( pawn, board, :right, :down )
      
      expect( PawnDiagonal::PawnDiagonalDown ).to have_received( :move_diagonal ).
        with( pawn, board, :right )
    end
    
    it "raises a TypeError when the constant does not exist" do
      expect{ described_class.
        create_for( pawn, board, :right, :side ) }.to raise_error TypeError
    end
  end
end