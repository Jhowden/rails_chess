require "rails_helper"

describe StartMoveSequence do
  let( :game ) { stub_model Game, board: [], player_turn: 5, white_team_id: 5, black_team_id: 2 }
  let( :king ) { double( "king" ) }
  let( :pieces ) { [piece1, piece2] }
  let( :user_input_map ) do
    {
      "piece_location" => { "file" => "a", "rank" => "4" },
      "target_location" => { "file" => "g", "rank" => "6" }
    }
  end
  let( :players_info ) { double( "players_info", 
    current_team: :white,
    cuurent_team_id: 5,
    enemy_team: :black,
    enemy_team_id: 2,
    json_board: "[]" ) }
  let( :observer ) { double( "observer", on_successful_move: nil, on_failed_move: nil ) }
  let( :standard_input ) { ParsedInput::Standard.new( user_input_map ) }
  let( :checkmate ) { double( "checkmate", match_finished?: true ) }
  let( :check_sequence ) { double( "check_sequence", valid_move?: true ) }
  let( :escape_moves ) { double( "escape_moves" ) }
  let( :board ) { double( "board", chess_board: [] ) }
  let( :user_input ) { double( "user_input", create!: nil ) }
  let( :piece1 ) { double( "piece1", 
    team: :white, 
    determine_possible_moves: [["a", 2, "a", 3], ["a", 2, "a", 4]] ) }
  let( :piece2 ) { double( "piece1", 
    team: :white, 
    determine_possible_moves: [["d", 4, "d", 5], 
                               ["d", 4, "d", 6], 
                               ["d", 4, "d", 7]] ) }
   
  let( :start_move_sequence ) { described_class.new( observer, standard_input, 3 ) }
  
  before :each do
    allow( Game ).to receive( :find ).and_return game
    allow( game ).to receive( :update_attributes )
    allow( game ).to receive( :user_inputs ).and_return user_input
    
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
    
    stub_const( "MoveSequence::StandardSequence", Class.new )
    allow( MoveSequence::StandardSequence ).to receive( :new ).and_return check_sequence
    allow( check_sequence ).to receive( :response ).and_return [board, "Sucessful move: a4b6"]
    
    stub_const( "MoveSequence::CastleSequence", Class.new )
    stub_const( "MoveSequence::EnPassantSequence", Class.new )
    stub_const( "MoveSequence::NullSequence", Class.new )
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
    
      context "when using Standard input" do
        subject( :start_move_sequence ) { described_class.new( observer, standard_input, 3 ) }
        it "calls to MoveSequence::StandardSequence" do
          subject.start
        
          expect( MoveSequence::StandardSequence ).to have_received( :new ).
            with( escape_moves, standard_input, players_info )
        end
      end
      
      context "when using EnPassant input" do
        let( :en_passant_input ) { ParsedInput::EnPassant.new( user_input_map ) }
        subject( :start_move_sequence ) { described_class.new( observer, en_passant_input, 3 ) }
        
        before :each do
          allow( MoveSequence::EnPassantSequence ).to receive( :new ).and_return check_sequence
          allow( check_sequence ).to receive( :response ).and_return [board, "Sucessful move: a4b6"]
        end
        
        it "calls to MoveSequence::EnPassantSequence" do
          subject.start
          
          expect( MoveSequence::EnPassantSequence ).to have_received( :new ).
            with( escape_moves, en_passant_input, players_info )
        end
      end
      
      context "when using Castle input" do
        let( :castle_input ) { ParsedInput::Castle.new( "0-0" ) }
        subject( :start_move_sequence ) { described_class.new( observer, castle_input, 3 ) }
        
        before :each do
          allow( MoveSequence::NullSequence ).to receive( :new ).and_return check_sequence
          allow( check_sequence ).to receive( :valid_move? ).
            and_return false
        end
        
        it "creates a NullSequence" do
          subject.start
          
          expect( MoveSequence::NullSequence ).to have_received( :new )
        end
        
        it "notifies the observer that it failed" do
          subject.start
          
          expect( observer ).to have_received( :on_failed_move ).
            with( "Invalid move. Please select another move." )
        end
      end
      
      
      it "checks if the move is valid" do
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
        
        it "checks for checkmate" do
          start_move_sequence.start
          
          expect( checkmate ).to have_received( :match_finished? )
        end
        
        it "updates the user_input for the game" do
          start_move_sequence.start
          
          expect( user_input ).to have_received( :create! ).
            with( "a4g6" )
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
              with( board: "[]", player_turn: 2 )
          end
          
          it "sends the messages to the observer" do
            start_move_sequence.start
          
            expect( observer ).to have_received( :on_successful_move ).
              with( "Sucessful move: a4b6" )
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
    
    context "when the player is not in check" do
      subject( :start_move_sequence ) { described_class.new( observer, standard_input, 3 ) }
      
      before :each do
        allow( GameStart::Check ).to receive( :king_in_check? ).and_return false
        allow( MoveSequence::StandardSequence ).to receive( :new ).
          and_return check_sequence
      end
      
      context "when given a Standard input" do
        it "calls a new StandardSequence" do
          subject.start
          
          expect( MoveSequence::StandardSequence ).to have_received( :new ).
            with( ["a2a3", "a2a4", "d4d5", "d4d6", "d4d7"], standard_input, players_info )
        end
      end
      
      it "checks if the move is valid" do
        subject.start

        expect( check_sequence ).to have_received( :valid_move? )
      end
      
      context "when using EnPassant input" do
        let( :en_passant_input ) { ParsedInput::EnPassant.new( user_input_map ) }
        subject( :start_move_sequence ) { described_class.new( observer, en_passant_input, 3 ) }
        
        before :each do
          allow( MoveSequence::EnPassantSequence ).to receive( :new ).and_return check_sequence
          allow( check_sequence ).to receive( :response ).and_return [board, "Sucessful move: a4b6"]
        end
        
        it "calls to MoveSequence::EnPassantSequence" do
          subject.start
          
          expect( MoveSequence::EnPassantSequence ).to have_received( :new ).
            with( ["a2a3", "a2a4", "d4d5", "d4d6", "d4d7"], en_passant_input, players_info )
        end
      end
      
      context "when using Castle input" do
        let( :castle_input ) { ParsedInput::Castle.new( "0-0" ) }
        subject( :start_move_sequence ) { described_class.new( observer, castle_input, 3 ) }
        
        before :each do
          allow( MoveSequence::CastleSequence ).to receive( :new ).and_return check_sequence
          allow( check_sequence ).to receive( :valid_move? ).
            and_return false
        end
        
        it "calls to MoveSequence::CastleSequence" do
          subject.start
          
          expect( MoveSequence::CastleSequence ).to have_received( :new )
        end
      end
      
      context "when it is a valid move" do
        before :each do
          allow( BoardJsonifier ).to receive( :jsonify_board ).
            and_return "[]"
        end
        
        it "calls for the response" do
          subject.start
          
          expect( check_sequence ).to have_received( :response )
        end
        
        it "checks for checkmate" do
          subject.start
          
          expect( checkmate ).to have_received( :match_finished? )
        end
        
        it "updates the user_input for the game" do
          subject.start
          
          expect( user_input ).to have_received( :create! ).
            with( "a4g6" )
        end
        
        context "when there is a winner" do
          it "updates the game with the winner" do
            subject.start
            
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
            subject.start
            
            expect( game ).to have_received( :update_attributes ).
              with( board: "[]", player_turn: 2 )
          end
          
          it "sends the messages to the observer" do
            subject .start
          
            expect( observer ).to have_received( :on_successful_move ).
              with( "Sucessful move: a4b6" )
          end
        end
      end
    end
  end
end