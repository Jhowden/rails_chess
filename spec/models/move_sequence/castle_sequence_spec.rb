require "rails_helper"
require "board_json_parser"

describe MoveSequence::CastleSequence do
  let( :queenside_input_map ) { { "castle" =>  "0-0-0"} }
  let( :kingside_input_map ) { { "castle" => "0-0"  } }
  let( :queenside_board ) do
    [[{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil],
    [nil, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :ending_queenside_board ) do
    [[nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"d", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil],
    [nil, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :kingside_board ) do
    [[nil, nil, nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"h", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :ending_kingside_board ) do
    [[nil, nil, nil, nil, nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"f", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"g", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  let( :invalid_castling_board ) do
    [[{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
    
  describe "#valid_move?" do
    context "when castling king side" do
      let( :input ) { ParsedInput::Castle.new kingside_input_map }
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :white, json_board: JSON.generate( kingside_board ) ) }
      let( :rook ) { GamePieces::Rook.new( 
        {"file" => "h",
         "rank" => 8,
         "team" => :white
        } ) }
      let( :king ) { GamePieces::Rook.new( 
        {"file" => "f",
         "rank" => 8,
         "team" => :white
        } ) }
      let( :board ) { double( "board" ) }
        
      subject( :seq ) { described_class.new( input, players_info ) }
      
      before :each do
        stub_const( "FindPieces::FindTeamPieces", Class.new )
        allow( FindPieces::FindTeamPieces ).to receive( :find_kingside_rook ).and_return rook
        allow( FindPieces::FindTeamPieces ).to receive( :find_king_piece ).and_return king
        
        stub_const( "Board", Class.new )
        allow( Board ).to receive( :new ).and_return board
      end
      
      it "finds the kingside rook" do
        subject.valid_move?
        
        expect( FindPieces::FindTeamPieces ).to have_received( :find_kingside_rook ).
          with( :white, board, 7, 0  )
      end
      
      it "finds the king" do
        subject.valid_move?
        
        expect( FindPieces::FindTeamPieces ).to have_received( :find_king_piece ).
          with( :white, board )
      end
      
      xit "checks if a king is in check after each move" do
      end
    end
  end
end