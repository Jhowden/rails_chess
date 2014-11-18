require "rails_helper"

describe NextFileLocation do
  let( :position ) { Position.new( "c", 5) }
  describe ".check_space_adjacent_space" do
    it "returns the next adjacent space index" do
      expect( described_class.check_space_adjacent_space( position ) ).to eq 3
    end
  end
end