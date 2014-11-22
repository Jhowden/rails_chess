require "rails_helper"

describe PawnForwardOne::PawnForwardOneFactory do
  let( :position ) { double( "position", file: nil, rank: nil ) }
  
  before :each do
    stub_const( "PawnForwardOne::PawnUpOne", Class.new )
    allow( PawnForwardOne::PawnUpOne ).to receive( :possible_move )
    
    stub_const( "PawnForwardOne::PawnDownOne", Class.new )
    allow( PawnForwardOne::PawnDownOne ).to receive( :possible_move )
  end
  
  describe ".create_for" do
    it "creates a PawnUpOne when orientation is up" do
      described_class.create_for( :up, position )
      
      expect( PawnForwardOne::PawnUpOne ).to have_received( :possible_move ).
        with position
    end
    
    it "creates a PawnDoenOne when orientation is down" do
      described_class.create_for( :down, position )
      
      expect( PawnForwardOne::PawnDownOne ).to have_received( :possible_move ).
        with position
    end
    
    it "raises an exception when it can't get constant" do
      expect{ described_class.create_for( :sideways, position ) }.to raise_error TypeError
    end
  end
end