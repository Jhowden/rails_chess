require "rails_helper"

describe PawnDiagonal::PawnDiagonalLeftDown do
  let( :board ) { double( "board" ) }
  let( :pawn ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 4, 
    "orientation" => :down, "board" => board, "team" => "black" } ) }
  
  before :each do
    allow( board ).to receive( :move_forward_diagonally? ).
      and_return true
  end

  describe ".move" do
    it "checks if the pawn can move diagonally" do
      described_class.move( pawn, board )
      
      expect( board ).to have_received( :move_forward_diagonally? ).
        with( pawn, :left )
    end
    
    it "returns a possible move" do
      expect( described_class.move( pawn, board ) ).to eq ["f", 3]
    end
  end
end