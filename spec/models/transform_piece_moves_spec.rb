require "rails_helper"

describe TransformPieceMoves do
  describe ".transform_moves" do
    context "when there is no en_passant" do
      let( :moves_list ) { [["a", 3, "b", 4], 
                            ["b", 5, "d", 6]]}
      it "removes the starting location from moves list" do
        expect( described_class.transform_moves( moves_list ) ).
          to eq( [["b", 4], ["d", 6]] )
      end
    end
    
    context "when there is en_passant" do
      let( :moves_list ) { [["a", 3, "b", 4, "e.p."]]}
      it "removes the starting location from moves list" do
        expect( described_class.transform_moves( moves_list ) ).
          to eq( [["b", 4, "e.p."]] )
      end
    end
  end
end