require "rails_helper"

describe PawnDiagonal::PawnDiagonalMovement do
  let( :pawn ) { double( "pawn" ) }
  let( :position ) { double( "position", rank: 4, file: "b" ) }
  
  before :each do
    allow( pawn ).to receive( :position ).and_return position
    allow( pawn ).to receive( :new_file_position ).and_return "a"
  end
  
  describe ".possible_move" do
    it "returns a new file position for pawn" do
       described_class.possible_move( pawn, :previous, 1 )
       
       expect( pawn ).to have_received( :new_file_position ).with :previous
    end
    
    it "returns a possible move" do
      expect( described_class.
        possible_move( pawn, :previous, 1 ) ).to eq ["b", 4, "a", 5]
    end
  end
end