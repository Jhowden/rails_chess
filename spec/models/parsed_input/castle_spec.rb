require "rails_helper"

describe ParsedInput::Castle do
  let( :input_type ) { described_class.new( "0-0" ) }
  
  describe "#input" do
    it "returns the correct input map" do
      expect( input_type.input ).to eq "castle" => "0-0"
    end
  end
  
  describe "#chess_notation" do
    it do
      expect( input_type.chess_notation ).to eq "0-0"
    end
  end
end