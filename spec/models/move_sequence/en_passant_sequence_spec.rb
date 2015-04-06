require "rails_helper"

describe MoveSequence::EnPassantSequence do
  let( :escape_moves ) { ["e5d6e.p.", "c4d4", "c4c3", "c4c5", "c4d5", "c4b4", "c4b5", "c4b3", "c4d4"] }
  let( :input_map ) do
    {
      "piece_location" => { "file" => "e", "rank" => "5" },
      "target_location" => { "file" => "d", "rank" => "6" },
    } 
  end
  let( :player_info ) { double( "player_info", current_team: :white,
    enemy_team: :black, json_board: JSON.generate( json_board ) ) }
  let( :input_type ) { ParsedInput::EnPassant.new input_map }
  let( :json_board ) do
    [[nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "d" , "rank" => 5, "team" => :black, "captured" => false, "move_counter" => 1, "orientation" => :down,  "capture_through_en_passant" => true}}, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "e" , "rank" => 5, "team" => :white, "captured" => false, "move_counter" => 2, "orientation" => :up,  "capture_through_en_passant" => true}}, nil, nil, nil],
    [nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>4, "team"=>:white, "captured"=>false, "move_counter"=>3, "checkmate"=>false}}, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :ending_json_board ) do
    JSON.generate( [
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "d" , "rank" => 6, "team" => :white, "captured" => false, "move_counter" => 3, "orientation" => :up,  "capture_through_en_passant" => true}}, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>4, "team"=>:white, "captured"=>false, "move_counter"=>3, "checkmate"=>false}}, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]] )
  end
  let( :parsed_board ) { BoardJsonParser.parse_json_board( 
    player_info.json_board ) }
  let( :game_board ) { Board.new parsed_board }
  let( :piece_position )  { double( "piece_position" ) }
  let( :enemy_position )  { double( "enemy_position" ) }
  let( :target_position )  { double( "target_position" ) }
  let( :check_seq ) { described_class.new( escape_moves, 
    input_type, 
    player_info ) }
    
  describe "valid_move?" do
    before :each do          
      allow( BoardJsonParser ).to receive( :parse_json_board ).and_return parsed_board
          
      allow( Board ).to receive( :new ).and_return game_board
    end
    
    context "when player_input matches escape moves" do
      it "returns true" do
        expect( check_seq.valid_move? ).to be_truthy
      end
      
      it "returns false when king is still in check" do
        allow( GameStart::Check ).to receive( :king_in_check? ).and_return true
        
        expect( check_seq.valid_move? ).to be_falsey
      end
      
      it "updates en_passant status for enemy pawn's" do
        allow( FindPieces::FindTeamPieces ).to receive( :find_pieces ).and_return []
        allow( EnPassantCommands ).to receive( :update_enemy_pawn_status_for_en_passant )
        
        check_seq.valid_move?
        
        expect( EnPassantCommands ).to have_received( :update_enemy_pawn_status_for_en_passant ).
          with( [], :black )
      end
    end      
    
    context "when it is an invalid move" do
      let( :input_map ) do
        {
          "piece_location" => { "file" => "a", "rank" => "5" },
          "target_location" => { "file" => "d", "rank" => "6" },
        }
      end
      let( :input_type )   { ParsedInput::EnPassant.new input_map }
      subject( :check_seq ){ described_class.new( escape_moves, 
        input_type, player_info ) }
        
      it "returns false" do
        expect( check_seq.valid_move? ).to be_falsey
      end
    end
  end
  
  describe "#response" do
    it "returns the updated board and message" do
      check_seq.valid_move?
      board, message = check_seq.response
      
      expect( BoardJsonifier.jsonify_board( board.chess_board ) ).to eq ending_json_board
      expect( message ).to match /Successful/
    end
  end
end