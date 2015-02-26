require "rails_helper"
require "board_json_parser"

describe MoveSequence::StandardKingInCheckSequence do
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
  let( :game ) { stub_model Game }
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
  let( :new_json_board ) do
    JSON.generate( [
      [nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>6, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil]
      ] )
  end
  let( :observer ) { double( "observer" ) }
  let( :parsed_board ) { BoardJsonParser.parse_json_board( player_info.json_board ) }
  let( :game_board ) { Board.new parsed_board }
  let( :check_seq ) { described_class.new( escape_moves, 
    input_type, 
    player_info,
    observer,
    game ) }
  
  describe "#valid_move?" do
    before :each do
      allow( GameStart::Check ).to receive( :king_in_check? ).and_return true
      
      allow( BoardJsonParser ).to receive( :parse_json_board ).and_return parsed_board
      
      allow( Board ).to receive( :new ).and_return game_board
      allow( game ).to receive( :update_attributes )
      
      allow( FindPieces::FindTeamPieces ).to receive( :find_king_piece )
      allow( FindPieces::FindTeamPieces ).to receive( :find_pieces )
    end
    
    context "when player_input matches escape moves" do
      it "parses the json board" do
        check_seq.valid_move?
      
        expect( BoardJsonParser ).to have_received( :parse_json_board ).with player_info.json_board
      end
      
      it "instantiates a new board" do
        check_seq.valid_move?
        
        expect( Board ).to have_received( :new ).with parsed_board
      end
      
      it "finds the king piece and the enemy pieces" do
        check_seq.valid_move?
        
        
        expect( FindPieces::FindTeamPieces ).to have_received( :find_king_piece ).
          with( :black, game_board )
        expect( FindPieces::FindTeamPieces ).to have_received( :find_pieces ).
          with( :white, game_board )
      end
      
      context "when it is a valid move" do
        it "returns true" do
          expect( check_seq.valid_move? ).to be_truthy
        end
      end
      
      context "when it is an invalid move" do
        it "returns false" do
          allow( GameStart::Check ).to receive( :king_in_check? ).and_return false
          
          expect( check_seq.valid_move? ).to be_falsey
        end
      end
    end
    
    context "when player_input does not match escape moves" do
      let( :escape_moves ) { ["h2b5"]}
      let( :check_seq ) { described_class.new( escape_moves, 
        input_type, 
        player_info,
        observer,
        game ) }
      it "returns a response" do
        expect( check_seq.valid_move? ).to be_falsey
      end
    end
  end
end