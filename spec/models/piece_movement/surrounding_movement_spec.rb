require "rails_helper"

describe PieceMovement::SurroundingMovement do
  let( :board ) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :piece ) { double( "piece", team: :white, board: board ) }
  let( :opposing_piece ) { double( team: :black ) }
  let( :friendly_piece ) { double( team: :white ) }
  
  subject { Board.new( board.chess_board ).extend( described_class, MoveValidations::Validations ) }
  
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