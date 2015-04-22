require "rails_helper"

describe PawnForwardTwo::PawnUpTwo do
  let( :position ) { double( "position", file: "d", rank: 3 ) }
  
  describe ".possible_move" do
    it "returns a possible move" do
      expect( described_class.possible_move( position ) ).to eq ["d", 3, "d", 5]
    end
  end
end