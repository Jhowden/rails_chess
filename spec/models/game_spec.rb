require "rails_helper"

describe Game, :type => :model do
  it "is valid with a board, white_team, black_team, and player_turn" do
    expect( FactoryGirl.build( :game ) ).to be_valid
  end
  
  it "is invalid without a board" do
      invalid_game = FactoryGirl.build( :game, board: nil )
      expect( invalid_game ).to be_invalid
  end
    
  it "is invalid without a white_team_id" do
    invalid_game = FactoryGirl.build( :game, white_team_id: nil )
    expect( invalid_game ).to be_invalid
  end
  
  it "is invalid without a black_team_id" do
    invalid_game = FactoryGirl.build( :game, black_team_id: nil )
    expect( invalid_game ).to be_invalid
  end
  
  it "is invalid without a player_turn" do
    invalid_game = FactoryGirl.build( :game, player_turn: nil )
    expect( invalid_game ).to be_invalid
  end
end