require "rails_helper"

describe PawnForwardOne::PawnDownOne do
  let( :position ) { double( "position", file: "f", rank: 4 ) }
  
  describe ".possible_move" do
    it "returns a possible move" do
      expect( described_class.possible_move( position ) ).to eq ["f", 3]
    end
  end
end