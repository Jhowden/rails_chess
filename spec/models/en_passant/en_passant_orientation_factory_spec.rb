require "rails_helper"

describe EnPassant::EnPassantOrientationFactory do
  let( :pawn ) { double( "pawn", orientation: :down ) }
  let( :pawn2 ) { double( "pawn2", orientation: :up ) }
  let( :faulty_pawn ) { double( "faulty_pawn", orientation: :north ) }
    
  before :each do
    stub_const( "EnPassant::DownEnPassantMoves", Class.new )
    allow( EnPassant::DownEnPassantMoves ).to receive( :new )
        
    stub_const( "EnPassant::UpEnPassantMoves", Class.new )
    allow( EnPassant::UpEnPassantMoves ).to receive( :new )
  end
  
  describe ".for_orientation" do
    context "when pawn is moving down" do
      it "gets the correct klass" do
        described_class.for_orientation( pawn )
        expect( EnPassant::DownEnPassantMoves ).to have_received( :new ).with pawn
      end
    end
    
    context "when pawn is moving up" do
      it "gets the correct klass" do
        described_class.for_orientation( pawn2 )
        expect( EnPassant::UpEnPassantMoves ).to have_received( :new ).with pawn2
      end
    end
    
    context "when invalid constant" do
      it "raises an error" do
        expect{ described_class.for_orientation( faulty_pawn ) }.to raise_error TypeError
      end
    end
  end
end