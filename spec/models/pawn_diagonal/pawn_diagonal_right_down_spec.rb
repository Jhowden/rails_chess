require "rails_helper"

describe PawnDiagonal::PawnDiagonalRightDown do
  let( :board ) { double( "board" ) }
  let( :pawn ) { GamePieces::Pawn.new( { file: "e", rank: 4, 
    orientation: :down, board: board } ) }
  
  before :each do
    allow( board ).to receive( :move_forward_diagonally? ).
      and_return true
  end

  describe ".move" do
    it "checks if the pawn can move diagonally" do
      described_class.move( pawn, board )
      
      expect( board ).to have_received( :move_forward_diagonally? ).
        with( pawn, :right )
    end
    
    it "returns a possible move" do
      expect( described_class.move( pawn, board ) ).to eq ["d", 3]
    end
  end
end