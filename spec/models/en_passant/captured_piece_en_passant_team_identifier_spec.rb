require "rails_helper"

describe EnPassant::CapturedPieceEnPassantTeamIdentifier do
  let( :pawn ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 4, "team" => :black, 
    "orientation" => :down, "capture_through_en_passant" => true } ) }
  let( :pawn2 ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 5, "team" => :white,
    "orientation" => :up, "capture_through_en_passant" => true } ) }
  
  describe ".select_pieces" do
    context "when team is black" do
      it "returns the pawns that can be captured through en_passant" do
        allow( pawn ).to receive( :move_counter ).and_return 1
        allow( pawn ).to receive( :captured? ).and_return false
      
        expect( described_class.select_pieces( [pawn, pawn2], :black ) ).to eq( [pawn] )
      end
    end
    
    context "when team is white" do
      it "returns the pawns that can be captured through en_passant" do
        allow( pawn2 ).to receive( :move_counter ).and_return 1
        allow( pawn2 ).to receive( :captured? ).and_return false
    
        expect( described_class.select_pieces( [pawn, pawn2], :white ) ).to eq( [pawn2] )
      end
    end
  end
end