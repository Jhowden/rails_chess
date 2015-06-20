require "rails_helper"
require "castle/queen_side"
require "board_jsonifier"

describe Castle::QueenSide do
  describe "can_castle?" do    
    context "when castling is valid" do
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :black, json_board: JSON.generate( queenside_board ) ) }
    
      subject( :queen_side ) { described_class.new( players_info ) }
      
      it "returns true" do
        expect( subject.can_castle? ).to be_truthy
      end
    end
    
    context "when castling is invalid" do
      let( :players_info ) { double( "player_info", current_team: :white,
        enemy_team: :black, json_board: JSON.generate( invalid_queenside_board ) ) }
    
      subject( :queen_side ) { described_class.new( players_info ) }
      
      it "returns false" do
        expect( subject.can_castle? ).to be_falsey
      end
    end
  end
  
  describe "#response" do
    let( :players_info ) { double( "player_info", current_team: :white,
      enemy_team: :black, json_board: JSON.generate( queenside_board ) ) }
      
    subject( :queen_side ) { described_class.new( players_info ) }
    
    it "returns the updated_board" do
      returned_board = subject.response.first
      expect( BoardJsonifier.jsonify_board( returned_board.chess_board ) ).
        to eq( JSON.generate( ending_queenside_board ) )
    end
    
    it "returns the message" do
      message = subject.response.last
      expect( message ).to match "Successful move:"
    end
  end

  def queenside_board()
    [[{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil],
    [nil, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  def ending_queenside_board()
    [[nil, nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>1, "checkmate"=>false}}, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"d", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>1}}, nil, nil, nil, nil],
    [nil, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  def invalid_queenside_board()
    [[{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, {"klass"=>"GamePieces::Queen", "attributes"=>{"file"=>"d", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"e", "rank"=>8, "team"=>:white, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
end