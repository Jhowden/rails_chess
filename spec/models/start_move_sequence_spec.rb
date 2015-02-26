require "rails_helper"

describe StartMoveSequence do
  let( :game ) { stub_model Game }
  let( :king ) { double( "king" ) }
  let( :pieces ) { double( "pieces" ) }
  let( :players_info ) { double( "players", 
    current_team: :white, 
    enemy_team: :black,
    json_board: "[]" ) }
  let( :player1 ) { stub_model User }
  let( :player2 ) { stub_model User }
  let( :observer ) { double( "observer" ) }
  let( :input ) { ParsedInput::Standard.new( {} ) }
  let( :checkmate ) { double( "checkmate" ) }
  let( :check_sequence ) { double( "check_sequence" ) }
  let( :escape_moves ) { double( "escape_moves" ) }
   
  let( :start_move_sequence ) { described_class.new( observer, input, 3 ) }
  
  before :each do
    allow( Game ).to receive( :find ).and_return game
    allow( game ).to receive( :board ).and_return []
    allow( game ).to receive( :player_turn ).and_return 5
    allow( game ).to receive( :white_team_id ).and_return 5
    allow( game ).to receive( :black_team_id ).and_return 2
    
    stub_const( "GameStart::PlayersInformation", Class.new )
    allow( GameStart::PlayersInformation ).to receive( :new ).
      and_return players_info
    
    stub_const( "GameStart::Check", Class.new )
    allow( GameStart::Check ).to receive( :king_in_check? ).and_return true
    
    stub_const( "GameStart::Checkmate", Class.new )
    allow( GameStart::Checkmate ).to receive( :new ).and_return checkmate
    allow( checkmate ).to receive( :find_checkmate_escape_moves ).and_return escape_moves
    
    stub_const( "FindPieces::FindTeamPieces", Class.new )
    allow( FindPieces::FindTeamPieces ).to receive( :find_pieces ).and_return pieces
    allow( FindPieces::FindTeamPieces ).to receive( :find_king_piece ).and_return king
    
    stub_const( "MoveSequence::StandardKingInCheckSequence", Class.new )
    allow( MoveSequence::StandardKingInCheckSequence ).to receive( :new ).and_return check_sequence
    allow( check_sequence ).to receive( :valid_move? )
  end
  
  describe "#start" do
    it "instantiates a Players object" do
      start_move_sequence.start
      
      expect( GameStart::PlayersInformation ).to have_received( :new ).with(
        {
          current_player:
          {id: 5, team: :white}, 
          enemy_player:
          {id: 2, team: :black}
          }, game.board
      )
    end
    
    context "when the player is in check" do
      it "checks to see if a player's king is in check" do
        start_move_sequence.start
      
        expect( GameStart::Check ).to have_received( :king_in_check? ).
          with( king, pieces )
      end
    
      it "instantiates a new Checkmate object" do
        start_move_sequence.start
      
        expect( GameStart::Checkmate ).to have_received( :new ).
          with( players_info.json_board, players_info.current_team, 
            players_info.enemy_team )
      end
    
      it "starts the player_in_check sequence when player is in check" do
        start_move_sequence.start
      
        expect( checkmate ).to have_received( :find_checkmate_escape_moves ).with( no_args )
      end
    
      it "calls to MoveSequence::StandardKingInCheckSequence" do
        start_move_sequence.start
        
        expect( MoveSequence::StandardKingInCheckSequence ).to have_received( :new ).
          with( escape_moves, 
            input, 
            players_info,
            observer,
            game
          )
      end
      
      it "performs the move" do
        start_move_sequence.start

        expect( check_sequence ).to have_received( :valid_move? )
      end
    end
  end
end