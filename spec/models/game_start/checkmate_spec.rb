require "rails_helper"

describe GameStart::Checkmate do
  let( :json_board )  { double( "json_board: ") }
  let( :king_escape_moves ) do
    [
      ["b", 8, "a", 8],
      ["b", 8, "b", 7],
    ]
  end
  let( :capture_piece_moves ) do
    [
      ["d", 7, "b", 7]
    ]
  end
  let( :block_piece_moves ) do
    [
      ["g", 5, "b", 7],
      ["d", 7, "b", 7]
    ]
  end
  let( :checkmate ) { described_class.new( json_board, :black, :white ) }
  
  before :each do
    stub_const( "CheckmateMoves::KingEscapeMoves", Class.new )
    allow( CheckmateMoves::KingEscapeMoves ).to receive( :find_moves ).and_return king_escape_moves
    
    stub_const( "CheckmateMoves::CapturePieceMoves", Class.new )
    allow( CheckmateMoves::CapturePieceMoves ).to receive( :find_moves ).and_return capture_piece_moves
    
    stub_const( "CheckmateMoves::BlockPieceMoves", Class.new )
    allow( CheckmateMoves::BlockPieceMoves ).to receive( :find_moves ).and_return block_piece_moves
  end
  
  describe "#find_checkmate_escape_moves" do
    context "when checking spaces a king can move" do
      it "calls Checkmate::KingEscapeMoves for moves" do
        checkmate.find_checkmate_escape_moves
        
        expect( CheckmateMoves::KingEscapeMoves ).to have_received( :find_moves ).
          with( json_board, :black, :white )
      end
      
      it "calls Checkmate::CapturePieceMoves for moves" do
        checkmate.find_checkmate_escape_moves
        
        expect( CheckmateMoves::CapturePieceMoves ).to have_received( :find_moves ).
          with( json_board, :black, :white )
      end
      
      it "calls Checkmate::BlockPieceMoves for moves" do
        checkmate.find_checkmate_escape_moves
        
        expect( CheckmateMoves::BlockPieceMoves ).to have_received( :find_moves ).
          with( json_board, :black, :white )
      end
      
      it "returns the correct moves" do
        expect( checkmate.find_checkmate_escape_moves ).to eq(
          [
            "b8a8",
            "b8b7",
            "d7b7",
            "g5b7",
          ]
        )
      end
    end
  end
end