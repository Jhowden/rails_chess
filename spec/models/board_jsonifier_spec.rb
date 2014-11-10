require 'rails_helper'

describe BoardJsonifier do
  let( :piece_board ) { double( "piece board" ) }
  let( :en_passant ) { double( "en_passant" ) }
  let( :rook ) { GamePieces::Rook.new( { file: "a", rank: 8, team: :white, board: piece_board, captured: false } ) }
  let( :bishop ) { GamePieces::Bishop.new( { file: "b", rank: 1, team: :black, board: piece_board, captured: false } ) }
  let( :pawn ) { GamePieces::Pawn.new( { file: "b", rank: 2, team: :black, 
    en_passant: en_passant, orientation: :up, capture_through_en_passant: true,
     board: piece_board, captured: false } ) }
  let( :king ) { GamePieces::King.new( { file: "a", rank: 7, team: :white, board: piece_board, 
    captured: false, checkmate: false } ) }
    
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
    [[{"klass" => GamePieces::Rook, "attributes" => {:file => "a", :rank => 8, :team => :white, :captured => false, :move_counter => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass" => GamePieces::King, "attributes" => {:file => "a", :rank => 7, :team => :white, :captured => false, :move_counter => 0, :checkmate => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => GamePieces::Pawn, "attributes" => {:file => "b" , :rank => 2, :team => :black, :captured => false, :move_counter => 0, :orientation => :up,  :capture_through_en_passant => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => GamePieces::Bishop, "attributes" => {:file => "b", :rank => 1, :team => :black, :captured => false, :move_counter => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  
  let( :transformed_rook ) { GamePieces::Rook.new( { file: "a", rank: 8, team: :white, board: nil, captured: false } ) }
  let( :transformed_bishop ) { GamePieces::Bishop.new( { file: "b", rank: 1, team: :black, board: nil, captured: false } ) }
  let( :transformed_pawn ) { GamePieces::Pawn.new( { file: "b", rank: 2, team: :black, 
    en_passant: nil, orientation: :up, capture_through_en_passant: true,
     board: nil, captured: false } ) }
  let( :transformed_king ) { GamePieces::King.new( { file: "a", rank: 7, team: :white, board: nil, 
    captured: false, checkmate: false } ) }
    
  let( :new_board ) do
    [[transformed_rook, nil, nil, nil, nil, nil, nil, nil], 
    [transformed_king, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, transformed_pawn, nil, nil, nil, nil, nil, nil], 
    [nil, transformed_bishop, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".jsonify_board" do    
    it "jsonifys the board" do
      expect( described_class.jsonify_board( board ) ).to eq transformed_board.to_json
    end
  end
  
  describe ".translate_json_board" do
    before :each do
      allow( JSON ).to receive( :parse ).and_return transformed_board
      allow( GamePieces::Rook ).to receive( :new )
      allow( GamePieces::Pawn ).to receive( :new )
      allow( GamePieces::King ).to receive( :new )
      allow( GamePieces::Bishop ).to receive( :new )
    end
    
    it "parses the JSON board" do
      json_board = transformed_board.to_json
      described_class.translate_json_board( json_board )
      expect( JSON ).to have_received( :parse ).with( json_board )
    end
    
    it "places a new instance of a Rook" do
      recreated_board = described_class.translate_json_board( transformed_board.to_json )
      expect(  GamePieces::Rook ).to have_received( :new ).with(
        {:file=>"a", :rank=>8, :team=>:white, :captured=>false, :move_counter=>0}
      )
    end
    
    it "places a new instance of a King" do
      recreated_board = described_class.translate_json_board( transformed_board.to_json )
      expect(  GamePieces::King ).to have_received( :new ).with(
        {:file => "a", :rank => 7, :team => :white, :captured => false, :move_counter => 0, :checkmate => false}
      )
    end
        
    it "places a new instance of a Pawn" do
      recreated_board = described_class.translate_json_board( transformed_board.to_json )
      expect(  GamePieces::Pawn ).to have_received( :new ).with(
        {:file => "b" , :rank => 2, :team => :black, :captured => false, :move_counter => 0, 
            :orientation => :up,  :capture_through_en_passant => true}
      )
    end
    
    it "places a new instance of a Bishop" do
      recreated_board = described_class.translate_json_board( transformed_board.to_json )
      expect(  GamePieces::Bishop ).to have_received( :new ).with(
        {:file => "b", :rank => 1, :team => :black, :captured => false, :move_counter => 0}
      )
    end
  end
end