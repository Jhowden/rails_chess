require 'rails_helper'

describe BoardJsonifier do
  let( :piece_board ) { double( "piece board" ) }
  let( :rook ) { GamePieces::Rook.new( { 
    "file" => "a", 
    "rank" => 8, 
    "team" => :white, 
    "board" => piece_board, 
    "captured" => false } ) }
  let( :bishop ) { GamePieces::Bishop.new( { 
    "file" => "b", 
    "rank" => 1, 
    "team" => :black, 
    "board" => piece_board, 
    "captured" => false } ) }
  let( :pawn ) { GamePieces::Pawn.new( { 
    "file" => "b", 
    "rank" => 2, 
    "team" => :black,
    "orientation" => :up, 
    "capture_through_en_passant" => true,
    "board" => piece_board, 
    "captured" => false } ) }
  let( :king ) { GamePieces::King.new( { 
    "file" => "a", 
    "rank" => 7, 
    "team" => :white, 
    "board" => piece_board, 
    "captured" => false, 
    "checkmate" => false } ) }
    
  let( :board ) do
    [[rook, nil, nil, nil, nil, nil, nil, nil], 
    [king, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, pawn, nil, nil, nil, nil, nil, nil], 
    [nil, bishop, nil, nil, nil, nil, nil, nil]]
  end

  let( :transformed_board ) do
    [[{"klass" => "GamePieces::Rook", "attributes" => {"file" => "a", "rank" => 8, "team" => :white, "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass" => "GamePieces::King", "attributes" => {"file" => "a", "rank" => 7, "team" => :white, "captured" => false, "move_counter" => 0, "checkmate" => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "b" , "rank" => 2, "team" => :black, "captured" => false, "move_counter" => 0, "orientation" => :up,  "capture_through_en_passant" => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Bishop", "attributes" => {"file" => "b", "rank" => 1, "team" => :black, "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".jsonify_board" do
    
    it "generates a json board" do
      allow( JSON ).to receive( :generate )
      
      described_class.jsonify_board board
      
      expect( JSON ).to have_received( :generate ).with transformed_board
    end
       
    it "jsonifys the board" do
      expect( described_class.jsonify_board( board ) ).to eq( JSON.generate( transformed_board ) )
    end
  end
end