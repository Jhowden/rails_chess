require 'rails_helper'

describe Board do
  let( :board ) { described_class.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :piece ) { double( position: Position.new( "f", 5 ), team: :black, orientation: :up, 
                        move_counter: 0 ) }
  let( :piece2 ) { double( position: Position.new( "a", 8 ), team: :white, orientation: :up,
                        move_counter: 1 ) }
  let( :rook ) { GamePieces::Rook.new( { file: "a", rank: 8, team: :white, captured: false } ) }
  let( :bishop ) { GamePieces::Bishop.new( { file: "b", rank: 1, team: :black, captured: false } ) }
  let( :pawn ) { GamePieces::Pawn.new( { file: "b", rank: 2, team: :black, 
    orientation: :up, capture_through_en_passant: true, captured: false } ) }
  let( :king ) { GamePieces::King.new( { file: "a", rank: 7, team: :white,
    captured: false, checkmate: false } ) }
  let( :pieces ) { [rook, pawn, bishop, king] }
  
  before :each do
    stub_const( "PiecesFactory", Class.new )
    allow( PiecesFactory ).to receive( :new ).and_return PiecesFactory
    allow( PiecesFactory ).to receive( :build ).and_return pieces
  end
  
  describe "#update_board" do
    context "when a space is occupied" do
      it "removes and replaces the opposing piece with new piece" do
        board.chess_board[3][5] = piece2
        allow( piece2 ).to receive( :captured! )
        board.update_board( piece )
        expect( board.chess_board[3][5] ).to eq( piece )
      end
      
      it "captures the piece occuping the spot" do
        board.chess_board[3][5] = piece2
        expect( piece2 ).to receive( :captured! )
        board.update_board( piece )
      end
    end
    
    context "when a space is open" do
      it "places the piece in the cell" do
        board.update_board( piece )
        expect( board.chess_board[3][5] ).to eq( piece )
      end
    end
  end
  
  describe "#place_pieces_on_board" do
    it "sets the team for the PiecesFactory" do
      board.place_pieces_on_board

      expect( PiecesFactory ).to have_received( :new ).with( :white )
      expect( PiecesFactory ).to have_received( :new ).with( :black )
    end
    
    it "builds the pieces" do
      board.place_pieces_on_board
      
      expect( PiecesFactory ).to have_received( :build ).exactly( :twice )
    end
    
    it "sets the pieces on the board" do
      board.place_pieces_on_board
      
      expect( board.chess_board[0][0] ).to be_an_instance_of GamePieces::Rook
      expect( board.chess_board[7][1] ).to be_an_instance_of GamePieces::Bishop
      expect( board.chess_board[6][1] ).to be_an_instance_of GamePieces::Pawn
      expect( board.chess_board[1][0] ).to be_an_instance_of GamePieces::King
    end
  end
end