require "rails_helper"

describe PreviousFileLocation do
  let( :position ) { Position.new( "h", 3) }
  
  describe ".check_space_adjacent_space" do
    it "returns the previous file index" do
      expect( described_class.check_space_adjacent_space( position ) ).to eq 6
    end
  end
end