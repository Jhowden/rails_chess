require 'rails_helper'

describe SendInviteSetup do
  let( :game ) { stub_model Game }
  let( :invite ) { stub_model Invitation }
  let( :params ) { {"receiver_id" => 2} }
  let( :board ) { stub_const( "Board", Class.new ) }
  let( :created_board ) { double() }
  let( :player ) { double( "player", id: 1 ) }
  let( :controller ) { double( "controller" ) }
  let( :send_invite_setup ) { described_class.new( controller, params, player ) }
  
  before :each do
    allow( board ).to receive( :new ).and_return board
    allow( board ).to receive( :create_board )
    
    allow( Game ).to receive( :new ).and_return game
    allow( game ).to receive( :save! ).and_return true
    allow( invite ).to receive( :create_game_link )
    
    allow( Invitation ).to receive( :new ).and_return invite
    allow( invite ).to receive( :save! ).and_return true
    
    allow( controller ).to receive( :invitation_successfully_created )
  end
  
  describe "#call" do
    it "creates the board for a Board" do
      send_invite_setup.call
      
      expect( board ).to have_received( :create_board )
    end
    
    it "instantiates a new Game" do
      send_invite_setup.call
      
      expect( Game ).to have_received( :new ).with( 
        white_team_id: 1,
        black_team_id: 2,
        board: board,
        player_turn: 1 )
    end
    
    context "when a game can NOT be saved" do
      it "sends a warning to the controller" do
        allow( game ).to receive( :save! ).and_return false
        allow( controller ).to receive( :invitation_failed_to_be_created )
        
        send_invite_setup.call
        
        expect( controller ).to have_received( :invitation_failed_to_be_created )
      end
    end
    
    context "when a game can be saved" do
      it "instantiates a new Invitation" do
        allow( game ).to receive( :id ).and_return 1
        
        send_invite_setup.call
        
        expect( Invitation ).to have_received( :new ).with(
          sender_id: player.id,
          receiver_id: 2,
          game_id: 1 )
      end
      
      it "sets the game link" do
        send_invite_setup.call
        
        expect( invite ).to have_received( :create_game_link )
      end
      
      context "when an Invitation can be saved" do
        it "notifies the controller that the Invitation has been saved" do
          send_invite_setup.call
          
          expect( controller ).to have_received( :invitation_successfully_created ).with invite
        end
      end
      
      context "when an Invitation can NOT be saved" do
        it "sends a warning to the controller" do
          allow( invite ).to receive( :save! ).and_return false
          allow( controller ).to receive( :invitation_failed_to_be_created )
        
          send_invite_setup.call
        
          expect( controller ).to have_received( :invitation_failed_to_be_created )
        end
      end
    end
  end
end