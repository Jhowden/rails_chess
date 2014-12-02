require "rails_helper"

describe UserCommand do
  let( :good_input ) do
    {
      "piece_location" => "a4", 
      "target_location" => "d6", 
      "en_passant" => "1"
    }
  end
  let( :bad_input ) do
    {
      "piece_location" => "a4", 
      "target_location" => "l6"
    }
  end
  let( :user_command ) { described_class.new( input ) }
  
  describe "#valid_input?" do
    it "returns true if the input is valid" do
      user_command = described_class.new good_input
      expect( user_command.valid_input? ).to be_truthy
    end
    
    it "returns false if the input is invalid" do
      user_command = described_class.new bad_input
      expect( user_command.valid_input? ).to be_falsey
    end
  end
  
  describe "#parsed_input" do
    context "when a player selected en_passant" do
      it "returns the parsed input" do
        user_command = described_class.new good_input
        expect( user_command.parsed_input ).to eq(
         {
           "piece_location" => { "file" => "a", "rank" => "4" },
           "target_location" => { "file" => "d", "rank" => "6" },
           "en_passant" => "e.p."
          } )
      end
    end
    
    context "when a player did NOT select en_passant" do
      it "returns the parsed input" do
        user_command = described_class.new bad_input
        expect( user_command.parsed_input ).to eq(
         {
           "piece_location" => { "file" => "a", "rank" => "4" },
           "target_location" => { "file" => "l", "rank" => "6" },
           "en_passant" => ""
          } )
      end
    end
  end
end