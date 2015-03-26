require "rails_helper"

describe StartMoveSequence do
  let( :game ) { stub_model Game }
  let( :king ) { double( "king" ) }
  let( :pieces ) { double( "pieces" ) }
  let( :players_info ) { double( "players_info", 
    current_team: :white,
    cuurent_team_id: 2,
    enemy_team: :black,
    enemy_team_id: 6,
    json_board: "[]" ) }
  let( :player1 ) { stub_model User }
  let( :player2 ) { stub_model User }
  let( :observer ) { double( "observer", on_successful_move: nil, on_failed_move: nil ) }
  let( :input ) { ParsedInput::Standard.new( {} ) }
  let( :checkmate ) { double( "checkmate", match_finished?: true ) }
  let( :check_sequence ) { double( "check_sequence" ) }
  let( :escape_moves ) { double( "escape_moves" ) }
  let( :board ) { double( "board", chess_board: [] ) }
   
  let( :start_move_sequence ) { described_class.new( observer, input, 3 ) }
  
  before :each do
    allow( Game ).to receive( :find ).and_return game
    allow( game ).to receive( :board ).and_return []
    allow( game ).to receive( :player_turn ).and_return 5
    allow( game ).to receive( :white_team_id ).and_return 5
    allow( game ).to receive( :black_team_id ).and_return 2
    allow( game ).to receive( :update_attributes )
    
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
    allow( check_sequence ).to receive( :valid_move? ).and_return true
    allow( check_sequence ).to receive( :response ).and_return [board, "Sucessful move: a4b6"]
  end
  
  it "instantiates a Players object" do
    start_move_sequence
    
    expect( GameStart::PlayersInformation ).to have_received( :new ).with(
      {
        current_player:
        {id: 5, team: :white}, 
        enemy_player:
        {id: 2, team: :black}
        }, game.board
    )
  end
  
  describe "#start" do    
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
            players_info.enemy_team ).at_least( :once )
      end
    
      it "starts the player_in_check sequence when player is in check" do
        start_move_sequence.start
      
        expect( checkmate ).to have_received( :find_checkmate_escape_moves ).
          with( no_args ).at_least( :once )
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
      
      context "when it is a valid move" do
        before :each do
          allow( BoardJsonifier ).to receive( :jsonify_board ).
            and_return "[]"
        end
        
        it "calls for the response" do
          start_move_sequence.start
          
          expect( check_sequence ).to have_received( :response )
        end
        
        it "sends the messages to the observer" do
          start_move_sequence.start
          
          expect( observer ).to have_received( :on_successful_move ).
            with( "Sucessful move: a4b6" )
        end
        
        it "checks for checkmate" do
          start_move_sequence.start
          
          expect( checkmate ).to have_received( :match_finished? )
        end
        
        context "when there is a winner" do
          it "updates the game with the winner" do
            start_move_sequence.start
            
            expect( game ).to have_received( :update_attributes ).
              with( board: "[]", winner: :white )
          end
        end
        
        context "when there is NOT a winner" do
          before :each do
            allow( checkmate ).to receive( :match_finished? ).
              and_return false
          end
          
          it "updates the game with new current player" do
            start_move_sequence.start
            
            expect( game ).to have_received( :update_attributes ).
              with( board: "[]", player_turn: 6 )
          end
        end
      end
      
      context "when it is not a valid move" do
        before :each do
          allow( check_sequence ).to receive( :valid_move? ).and_return false
        end
        
        it "calls off to the observer" do
          start_move_sequence.start
          
          expect( observer ).to have_received( :on_failed_move ).
            with( "Invalid move. Please select another move." )
        end
      end
    end
  end
end