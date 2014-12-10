require "rails_helper"

describe UserCommand do
  let( :good_input ) do
    {
      "piece_location"  => "a4", 
      "target_location" => "d6", 
      "en_passant"      => "e.p."
    }
  end
  
  let( :standard_input ) do
    {
      "piece_location"  => "a4", 
      "target_location" => "d6"
    }
  end
  
  let( :bad_input ) do
    {
      "piece_location"  => "a4", 
      "target_location" => "l6"
    }
  end
  
  let( :castle_and_regular_bad_input ) do
    {
      "piece_location"  => "a4", 
      "target_location" => "d6", 
      "castle"          => "0-0"
    }
  end
  
  let( :ep_and_castle_bad_input ) do
    {
      "piece_location"  => "", 
      "target_location" => "", 
      "en_passant"      => "e.p.",
      "castle"          => "0-0"
    }
  end
  
  let( :queen_castle_input ) do
    {
      "piece_location"    => "", 
      "target_location"   => "", 
      "castle"            => "0-0-0"
    }
  end
  
  let( :king_castle_input ) do
    {
      "piece_location"    => "", 
      "target_location"   => "", 
      "castle"            => "0-0"
    }
  end
  
  let( :user_command ) { described_class.new( input ) }
  
  before :each do
    stub_const( "ParsedInput::Standard", Class.new )
    allow( ParsedInput::Standard ).to receive( :new )
    
    stub_const( "ParsedInput::EnPassant", Class.new )
    allow( ParsedInput::EnPassant ).to receive( :new )
    
    stub_const( "ParsedInput::Castle", Class.new )
    allow( ParsedInput::Castle ).to receive( :new )
  end
  
  describe "#valid_input?" do
    context "when input is valid" do
      it "returns true if the target and piece location range is valid" do
        user_command = described_class.new good_input
        expect( user_command.valid_input? ).to be_truthy
      end
    
      it "returns true if user selects to castle" do
        user_command = described_class.new queen_castle_input
        expect( user_command.valid_input? ).to be_truthy
      end
    end

    context "when an invalid input" do
      it "returns false if the target and piece location range is invalid" do
        user_command = described_class.new bad_input
        expect( user_command.valid_input? ).to be_falsey
      end
      
      it "returns false if there is piece and/or target location selected with castle" do
        user_command = described_class.new castle_and_regular_bad_input
        expect( user_command.valid_input? ).to be_falsey
      end
      
      it "returns false if en_passant is selected with castle" do
        user_command = described_class.new ep_and_castle_bad_input
        expect( user_command.valid_input? ).to be_falsey
      end
    end
  end
  
  describe "#get_input" do
    context "when a player selected en_passant" do
      it "returns the input type" do
        user_command = described_class.new good_input
        
        user_command.get_input
        
        expect( ParsedInput::EnPassant ).to have_received( :new ).with(
           {
             "piece_location" => { "file" => "a", "rank" => "4" },
             "target_location" => { "file" => "d", "rank" => "6" }
            }
          )
      end
    end
    
    context "when a player did NOT select en_passant" do
      it "returns the input type" do
        user_command = described_class.new standard_input
        
        user_command.get_input
        
        expect( ParsedInput::Standard ).to have_received( :new ).with( 
            {
              "piece_location" => { "file" => "a", "rank" => "4" },
              "target_location" => { "file" => "d", "rank" => "6" }
             }
           )
      end
    end
    
    context "when player selected king_side_castle" do
      it "returns the input type" do
        user_command = described_class.new king_castle_input
        
        user_command.get_input
        
        expect( ParsedInput::Castle ).to have_received( :new ).with(
          "0-0"
        )
      end
    end
    
    context "when player selected queen_side_castle" do
      it "returns the input type" do
        user_command = described_class.new queen_castle_input
        
        user_command.get_input
        
        expect( ParsedInput::Castle ).to have_received( :new ).with(
          "0-0-0"
        )
      end
    end
  end
end