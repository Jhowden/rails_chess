require 'rails_helper'

describe BoardJsonifier do
  let( :piece_board ) { double( "piece board" ) }
  let( :en_passant ) { double( "stupid en_passant" ) }
  let( :rook ) { GamePieces::Rook.new( { file: "a", rank: 8, team: :white, board: piece_board, captured: false } ) }
  let( :bishop ) { GamePieces::Bishop.new( { file: "b", rank: 1, team: :black, board: piece_board, captured: false } ) }
  let( :pawn ) { GamePieces::Pawn.new( { file: "b", rank: 2, team: :black, 
    orientation: :up, capture_through_en_passant: true, 
    en_passant: en_passant, board: piece_board, captured: false } ) }
  let( :king ) { GamePieces::King.new( { file: "a", rank: 7, team: :white, board: piece_board, 
    captured: false, checkmate: false } ) }
  let( :board ) { Array.new( 8 ) { |cell| Array.new( 8 ) } }
  let( :transformed_board ) do
    [[{GamePieces::Rook=>{:file => "a", :rank => 8, :team => :white, :captured => false, :move_counter => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{GamePieces::King=>{:file => "a", :rank => 7, :team => :white, :captured => false, :move_counter => 0, :checkmate => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {GamePieces::Pawn=>{:file => "b" , :rank => 2, :team => :black, :captured => false, :move_counter => 0, :orientation => :up,  :capture_through_en_passant => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {GamePieces::Bishop=>{:file => "b", :rank => 1, :team => :black, :captured => false, :move_counter => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".jsonify_board" do
    before :each do
      board[0][0] = rook
      board[7][1] = bishop
      board[6][1] = pawn
      board[1][0] = king
    end
    
    it "jsonifys the board" do
      expect( described_class.jsonify_board( board ) ).to eq transformed_board.to_json
    end
  end
end