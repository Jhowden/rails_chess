require "rails_helper"

describe GameStart::Checkmate do
  let( :json_board )  { double( "json_board: ") }
  let( :king_escape_moves ) do
    [
      ["b", 8, "a", 8],
      ["b", 8, "b", 7],
    ]
  end
  let( :checkmate ) { described_class.new( json_board, :black, :white ) }
  
  before :each do
    stub_const( "CheckmateMoves::KingEscapeMoves", Class.new )
    allow( CheckmateMoves::KingEscapeMoves ).to receive( :find_moves ).and_return king_escape_moves
  end
  
  describe "#find_checkmate_escape_moves" do
    context "when checking spaces a king can move" do
      it "calls Checkmate::KingEscapeMoves for moves" do
        checkmate.find_checkmate_escape_moves
        
        expect( CheckmateMoves::KingEscapeMoves ).to have_received( :find_moves ).
          with( json_board, :black, :white )
      end
    end
  end
end