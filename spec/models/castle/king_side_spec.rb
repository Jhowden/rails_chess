require "rails_helper"
require "castle"
require "board_jsonifier"

describe Castle::KingSide do
  describe "can_castle?" do    
    context "when castling is valid" do
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :black, json_board: JSON.generate( kingside_board ) ) }
    
      subject( :king_side ) { described_class.new( players_info ) }
      
      it "checks to see it is a valid castle move" do
        expect( subject.can_castle? ).to be_truthy
      end
    end
  end
  
  describe "#response" do
    let( :players_info ) { double( "player_info", current_team: :white,
      enemy_team: :black, json_board: JSON.generate( kingside_board ) ) }
      
    subject( :king_side ) { described_class.new( players_info ) }
    
    it "returns the updated_board" do
      returned_board = subject.response.first
      expect( BoardJsonifier.jsonify_board( returned_board.chess_board ) ).
        to eq( JSON.generate( ending_kingside_board ) )
    end
    
    it "returns the message" do
      message = subject.response.last
      expect( message ).to match "Successful move:"
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
    [[nil, nil, nil, nil, nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"f", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>1}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"g", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>1, "checkmate"=>false}}, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
end