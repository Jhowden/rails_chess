require 'rails_helper'

describe InvitationsController do
  let( :send_invite_setup ) { double( "send_invite_setup", call: nil ) }
  let( :params ) { {"receiver_id" => "2", "controller"=>"invitations", "action"=>"send_invite"} }
  let( :player ) { FactoryGirl.create( :user ) }
  let( :invitation ) { double( "invitation", game_link: "game/1/home" ) }
  
  describe "POST #send_invite" do
    before :each do
      stub_const "SendInviteSetup", Class.new
      allow( SendInviteSetup ).to receive( :new ).and_return send_invite_setup
      session[:user_id] = player.id
    end
    
    it "instantiates a new SendInviteSetup" do
      post :send_invite, params
      
      expect( SendInviteSetup ).to have_received( :new ).
        with( controller, params, player )
    end
    
    it "creates the game and invitation" do
      post :send_invite, params
      
      expect( send_invite_setup ).to have_received( :call )
    end
    
    it "redirects to the User's page" do
      post :send_invite, params
      
      expect( response ).to redirect_to users_path( player )
    end
    
    after :each do
      session.clear
    end
  end
  
  describe "#invitation_successfully_created" do
    it "sets a successful flash message" do
      controller.invitation_successfully_created( invitation )

      expect( flash.notice ).to match /Successfully/
    end
  end
  
  describe "#invitation_failed_to_be_created" do
    it "sets a failing flash message" do
      controller.invitation_failed_to_be_created
      
      expect( flash[:error] ).to match /Failed/
    end
  end
end