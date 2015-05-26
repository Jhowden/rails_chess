require "rails_helper"
require "castle"

describe Castle::KingSide do
  
  before :each do
     stub_const( "BoardJsonParser", Class.new )
    stub_const( "Board", Class.new )
  end
  
  describe "#initialize" do
    subject( :king_side ) { described_class.new( 
      double( "players_info", json_board: [] ) ) }
    
    before :each do
      allow( BoardJsonParser ).to receive( :parse_json_board ).
      and_return []
      
      stub_const( "Board", Class.new )
      allow( Board ).to receive( :new )
    end
  
    it do
      subject
    
      expect( BoardJsonParser ).to have_received( :parse_json_board ).
        with []
    end
    
    it do
      subject
      expect( Board ).to have_received( :new ).with []
    end
  end
  
  describe "can_castle?" do    
    context "when castling is valid" do
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
      let( :pieces ) { double( "pieces" ) }
    
      subject( :king_side ) { described_class.new( players_info ) }
      
      before :each do
        stub_const( "FindPieces::FindTeamPieces", Class.new )
        allow( FindPieces::FindTeamPieces ).to receive( :find_kingside_rook ).and_return rook
        allow( FindPieces::FindTeamPieces ).to receive( :find_king_piece ).and_return king
        allow( FindPieces::FindTeamPieces ).to receive( :find_pieces ).and_return pieces
        
        allow( BoardJsonParser ).to receive( :parse_json_board )

        allow( Board ).to receive( :new ).and_return board
      end
      
      it "finds the kingside rook" do
        subject.can_castle?
    
        expect( FindPieces::FindTeamPieces ).to have_received( :find_kingside_rook ).
          with( :white, board, 7, 0  )
      end
  
      it "finds the king" do
        subject.can_castle?
    
        expect( FindPieces::FindTeamPieces ).to have_received( :find_king_piece ).
          with( :white, board )
      end
    end
  end
  
  def kingside_board
    [[nil, nil, nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"h", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  def ending_kingside_board
    [[nil, nil, nil, nil, nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"f", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"g", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
end