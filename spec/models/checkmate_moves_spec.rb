require "rails_helper"

describe CheckmateMoves do
  let( :board ) { double( "board" ) }
  
  describe ".find_king" do
    it "finds a team's king piece" do
      allow( FindPieces::FindTeamPieces ).to receive( :find_king_piece )
      described_class.find_king( :white, board )
      expect( FindPieces::FindTeamPieces ).to have_received( :find_king_piece ).
        with( :white, board )
    end
  end
  
  describe ".find_team_pieces" do
    it "finds a team's king piece" do
      allow( FindPieces::FindTeamPieces ).to receive( :find_pieces )
      described_class.find_team_pieces( :white, board )
      expect( FindPieces::FindTeamPieces ).to have_received( :find_pieces ).
        with( :white, board )
    end
  end
end