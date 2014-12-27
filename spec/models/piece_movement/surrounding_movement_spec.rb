require "rails_helper"

describe PieceMovement::SurroundingMovement do
  subject { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ).extend( described_class, MoveValidations::Validations ) }
  
  let(:piece) { double( "piece", team: :white ) }
  let(:opposing_piece) { double( team: :black ) }
  let(:friendly_piece) { double( team: :white ) }
  
  describe "#find_surrounding_spaces" do
    it "finds the valid moves for a knight or king" do
      expect( subject.find_surrounding_spaces( 4, 3, piece, [[-1, -2], [-2, -1], [1, -2]] ) ).to eq( 
        [["d", 7], ["c", 6], ["f", 7]]
      )
    end
    
    it "includes spaces where there is an enemy" do
      subject.chess_board[2][2] = opposing_piece
      
      expect( subject.find_surrounding_spaces( 4, 3, piece, [[-1, -2], [-2, -1], [1, -2]] ) ).to eq( 
        [["d", 7], ["c", 6], ["f", 7]]
      )
    end
    
    it "excludes spaces where there is a friendly piece" do
      subject.chess_board[2][2] = friendly_piece
      
      expect( subject.find_surrounding_spaces( 4, 3, piece, [[-1, -2], [-2, -1], [1, -2]] ) ).to eq( 
        [["d", 7], ["f", 7]]
      )
    end
  end
end