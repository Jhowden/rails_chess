require "rails_helper"

describe GameStart::Check do
  let( :king )   { double( "king" ) }
  let( :rook )   { double( "rook", captured?: false, determine_possible_moves: [["a", 3], ["a", 4]] ) }
  let( :bishop ) { double( "rook", captured?: false, determine_possible_moves: [["a",4], ["b", 3]] ) }
  
  describe ".king_in_check?" do
    before :each do
      allow( king ).to receive( :check? )
    end
    
    it "returns true when the king is in check" do
      described_class.king_in_check?( king, [rook, bishop] )
      expect( king ).to have_received( :check? ).with( [["a", 3], ["a", 4], ["a",4], ["b", 3]] )
    end
  end
end