require "rails_helper"

describe PawnForwardTwo::PawnForwardTwoFactory do
  let( :position ) { double( "position", file: nil, rank: nil) }
  
  before :each do
    stub_const( "PawnForwardTwo::PawnDownTwo", Class.new )
    allow( PawnForwardTwo::PawnDownTwo ).to receive( :possible_move )
    
    stub_const( "PawnForwardTwo::PawnUpTwo", Class.new )
    allow( PawnForwardTwo::PawnUpTwo ).to receive( :possible_move )
  end
  
  describe ".create_for" do
    it "creates a PawnDownTwo when pawn orientation is down" do
      described_class.create_for( :down, position )
      expect( PawnForwardTwo::PawnDownTwo ).to have_received( :possible_move ).with position
    end
    
    it "creates a PawnDownTwo when pawn orientation is up" do
      described_class.create_for( :up, position )
      expect( PawnForwardTwo::PawnUpTwo ).to have_received( :possible_move ).with position
    end
    
    it "raises an exception when it can't get constant" do
      expect{ described_class.create_for( :sideways, position ) }.to raise_error TypeError
    end
  end
end