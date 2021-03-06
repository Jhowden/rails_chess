require "rails_helper"
require "board_json_parser"

describe MoveSequence::StandardSequence do
  let( :escape_moves ) { ["a3a6", "f6b6"] }
  let( :input_map ) do
    {
      "piece_location" => 
        { 
          "file" => "a", 
          "rank" => "3"
        },
      "target_location" => 
        {
          "file" => "a", 
          "rank" => "6"
        }
      }
  end
  let( :player_info ) { double( "player_info", current_team: :black,
    enemy_team: :white, json_board: JSON.generate( json_board ) ) }
  let( :input_type ) { ParsedInput::Standard.new input_map }
  let( :json_board ) do
    [[nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [{"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"a", "rank"=>6, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>3, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :ending_json_board ) do
    JSON.generate( [
      [nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>6, "team"=>:black, "captured"=>false, "move_counter"=>1}}, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]] )
  end
  let( :parsed_board ) { BoardJsonParser.parse_json_board( player_info.json_board ) }
  let( :game_board ) { Board.new parsed_board }
  let( :check_seq ) { described_class.new( escape_moves, 
    input_type, 
    player_info ) }
  
  describe "#valid_move?" do
    before :each do
      allow( BoardJsonParser ).to receive( :parse_json_board ).and_return parsed_board
      
      allow( Board ).to receive( :new ).and_return game_board
    end
    
    context "when player_input matches escape moves" do
      it "returns true" do
        expect( check_seq.valid_move? ).to be_truthy
      end
      
      it "updates en_passant status for enemy pawn's" do
        allow( EnPassantCommands ).to receive( :update_enemy_pawn_status_for_en_passant )
        
        check_seq.valid_move?
        
        expect( EnPassantCommands ).to have_received( :update_enemy_pawn_status_for_en_passant ).
          with( [], :white )
      end
      
      context "when it is an invalid move" do
        it "returns false" do
          allow( GameStart::Check ).to receive( :king_in_check? ).and_return true
          
          expect( check_seq.valid_move? ).to be_falsey
        end
      end
    end
    
    context "when trying to move piece from wrong team" do
      it "returns false" do
        allow( player_info ).to receive( :current_team ).and_return :white
        
        expect( check_seq.valid_move? ).to be_falsey
      end
    end
    
    context "when player_input does not match escape moves" do
      let( :escape_moves ) { ["h2b5"]}
      let( :check_seq ) { described_class.new( escape_moves, 
        input_type, 
        player_info ) }
        
      it "returns a false" do
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