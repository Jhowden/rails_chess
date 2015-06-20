require "rails_helper"
require "board_json_parser"

describe MoveSequence::CastleSequence do
  let( :king_side ) { double( "king_side" ) }
  let( :queen_side ) { double( "queen_side" ) }
  let( :queenside_input_map ) { "0-0-0" }
  let( :kingside_input_map )  { "0-0" }
  
  before :each do
    stub_const( "Castle::KingSide", Class.new )
    stub_const( "Castle::QueenSide", Class.new )
  end
    
  describe "#valid_move?" do
    context "when castling King side" do
      let( :input ) { ParsedInput::Castle.new kingside_input_map }
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :white, json_board: "[]" ) }
        
      subject( :seq ) { described_class.new( input, players_info ) }
      
      before :each do
        allow( Castle::KingSide ).to receive( :new ).and_return king_side
        allow( king_side ).to receive( :can_castle? )
      end
      
      it "instantiates the correct Castle Object" do
        subject.valid_move?
        
        expect( Castle::KingSide ).to have_received( :new ).with players_info
      end
      
      it "checks if the king can castle" do
        subject.valid_move?
        
        expect( king_side ).to have_received( :can_castle? )
      end
      
      context "when castling Queen side" do
        let( :input ) { ParsedInput::Castle.new queenside_input_map }
        let( :players_info ) { double( "player_info", current_team: :white,
          enemy_team: :white, json_board: "[]" ) }
        
        subject( :seq ) { described_class.new( input, players_info ) }
      
        before :each do
          allow( Castle::QueenSide ).to receive( :new ).and_return queen_side
          allow( queen_side ).to receive( :can_castle? )
        end
      
        it "instantiates the correct Castle Object" do
          subject.valid_move?
        
          expect( Castle::QueenSide ).to have_received( :new ).with players_info
        end
      
        it "checks if the king can castle" do
          subject.valid_move?
        
          expect( queen_side ).to have_received( :can_castle? )
        end
      end
    end
    
    describe "#response" do
      let( :input ) { ParsedInput::Castle.new kingside_input_map }
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :white, json_board: "[]" ) }
        
      subject( :seq ) { described_class.new( input, players_info ) }
      
      before :each do
        allow( Castle::KingSide ).to receive( :new ).and_return king_side
        allow( king_side ).to receive( :can_castle? ).and_return true
      end
      
      it "calls off for the response and message" do
        allow( king_side ).to receive( :response )
        
        subject.response
        
        expect( king_side ).to have_received( :response )
      end
    end
  end
end