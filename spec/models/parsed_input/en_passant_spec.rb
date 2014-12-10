require "rails_helper"

describe ParsedInput::EnPassant do
  let( :starting_map ) do
    {
      "piece_location" => { "file" => "a", "rank" => "4" },
      "target_location" => { "file" => "l", "rank" => "6" }
     }
  end
  
  let( :input_type ) { described_class.new( starting_map ) }
  
  describe "#input" do
    it "returns the correct input map" do
      expect( input_type.input ).to eq( starting_map.merge( "en_passant" => "e.p." ) )
    end
  end
end