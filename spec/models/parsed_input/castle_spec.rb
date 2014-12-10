require "rails_helper"

describe ParsedInput::Castle do
  let( :input_type ) { described_class.new( "0-0" ) }
  
  describe "#input" do
    it "returns the correct input map" do
      expect( input_type.input ).to eq "castle" => "0-0"
    end
  end
end