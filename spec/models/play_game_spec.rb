require "rails_helper"

describe PlayGame do
  let( :params ) do
     { 
      "controller" => "games", 
      "action" => "input",
      "piece_location" => "a4", 
      "target_location" => "d6", 
      "en_passant" => "1", 
      "commit" => "Submit Move", 
      "game_id" => "8"
    }
  end
  let( :observer ) { double( "observer", on_invalid_input: nil ) }
  let( :playgame ) { described_class.new params, observer }
  let( :user_command ) { double( "user_command" ) }
  
  before :each do
    stub_const( "UserCommand", Class.new )
    allow( UserCommand ).to receive( :new ).and_return user_command
    allow( user_command ).to receive( :valid_input? ).and_return true
    allow( user_command ).to receive( :parse )
  end
  
  describe "#call" do
    it "instantiates a UserCommand" do
      playgame.call
      
      expect( UserCommand ).to have_received( :new ).with( params )
    end
    
    it "parses the input" do
      playgame.call
      
      expect( user_command ).to have_received( :valid_input? )
    end
    
    context "when the input is invalid" do
      it "messages the controller that it failed" do
        allow( user_command ).to receive( :valid_input? ).and_return false
        
        playgame.call
        
        expect( observer ).to have_received( :on_invalid_input )
      end
    end
  end
end