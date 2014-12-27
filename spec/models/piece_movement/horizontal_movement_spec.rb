require "rails_helper"

describe PieceMovement::HorizontalMovement do
  let( :board ) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :piece ) { double( team: :white, board: board ) }
  let( :opposing_piece ) { double( team: :black ) }
  let( :friendly_piece ) { double( team: :white ) }
  
  subject { Board.new( board.chess_board ).extend( described_class, MoveValidations::Validations ) }
  
  describe "#find_possible_horizontal_spaces" do
    context "when moving to the left" do
      it "finds all the empty spaces to the left of the piece" do
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, -1 ) ).to eq( 
          [["d", 5], ["c", 5], ["b", 5], ["a", 5]] 
        )
      end
      
      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[3][2] = opposing_piece
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, -1 ) ).to eq( [["d", 5], ["c", 5]] )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[3][2] = friendly_piece
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, -1 ) ).to eq( [["d", 5]] )
      end
    end
  
    context "when moving to the right" do
      it "finds all the empty spaces to the left of the piece" do
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, 1 ) ).to eq( [["f", 5], ["g", 5], ["h",5]] )
      end

      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[3][6] = opposing_piece
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, 1 ) ).to eq( [["f", 5], ["g",5 ]] )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[3][6] = friendly_piece
        expect( subject.find_possible_horizontal_spaces( 4, 3, piece, 1 ) ).to eq( [["f", 5]] )
      end
    end
  end
end