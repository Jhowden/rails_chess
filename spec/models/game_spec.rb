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
  
  describe ".determine_players_status" do
    it "returns hash with the enemy players' id and team when current player is white team" do
      game = FactoryGirl.build( :game )
      expect( game.determine_players_status() ).to eq( 
        {
          current_player: {id: 6, team: :white},
          enemy_player: {id: 5, team: :black}
        } 
      )
    end
    
    it "returns hash with the players' id and team when current player is black team" do
      game = FactoryGirl.build( :game, white_team_id: 1, black_team_id: 3, player_turn: 3 )
      expect( game.determine_players_status() ).to eq( 
        {
          current_player: {id: 3, team: :black}, 
          enemy_player: {id: 1, team: :white}
        }
      )
    end
  end
end