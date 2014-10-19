require "rails_helper"

describe Invitation, :type => :model do
  it "is valid with a sender_id, receiver_id, game_link, and game_id" do
    expect( FactoryGirl.build( :invitation ) ).to be_valid
  end
  
  it "is invalid without a sender_id" do
      invalid_invitation = FactoryGirl.build( :invitation, sender_id: nil )
      expect( invalid_invitation ).to be_invalid
  end

  it "is invalid without a receiver_id" do
    invalid_invitation = FactoryGirl.build( :invitation, receiver_id: nil )
    expect( invalid_invitation ).to be_invalid
  end

  it "is invalid without a game_link" do
    invalid_invitation = FactoryGirl.build( :invitation, game_link: nil )
    expect( invalid_invitation ).to be_invalid
  end

  it "is invalid without a game_id" do
    invalid_invitation = FactoryGirl.build( :invitation, game_id: nil )
    expect( invalid_invitation ).to be_invalid
  end
  
  describe ".create_game_link" do
    it "creates the game_link" do
      invitation = Invitation.new( game_id: 7 )
      expect( invitation.create_game_link ).to eq( "game/7/home")
    end
  end
end