require "rails_helper"

describe PawnForwardTwo::PawnDownTwo do
  let( :position ) { double( "position", file: "d", rank: 3 ) }
  
  describe ".possible_move" do
    it "returns a possible move" do
      expect( described_class.possible_move( position ) ).to eq ["d", 3, "d", 1]
    end
  end
end