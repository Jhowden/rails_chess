require "rails_helper"

describe PieceMovement::DiagonalMovement do
  subject { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ).extend( described_class, MoveValidations::Validations ) }
  
  let(:piece) { double( team: :white) }
  let(:opposing_piece) { double( team: :black) }
  let(:friendly_piece) { double( team: :white) }
  
  describe "#find_possible_diagonally_spaces" do
    context "when finding spaces to the top left" do
      it "finds all the empty spaces to the top-left of the piece" do
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 ) ).to eq( 
          [["d", 6], ["c", 7], ["b", 8]]
        )
      end
      
      it "finds a space occupied by an enemy to the top-left of the piece" do
        subject.chess_board[1][2] = opposing_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 ) ).to eq(
          [["d", 6], ["c", 7]]
        )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][2] = friendly_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, -1 ) ).to eq(
          [["d", 6]]
        )
      end
    end
    
    context "when finding spaces to the top right" do
      it "finds all the empty spaces to the top-right of the piece" do
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 ) ).to eq(
          [["f", 6], ["g", 7], ["h",8]]
        )
      end
 
      it "finds a space occupied by an enemy to the left of the piece" do
        subject.chess_board[1][6] = opposing_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 ) ).to eq(
          [["f", 6], ["g", 7]]
        )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][6] = friendly_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, -1, 1 ) ).to eq(
          [["f", 6]]
        )
      end
    end
    
    context "when finding spaces to the bottom left" do
      it "finds all the empty spaces to the bottom-left of the piece" do
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 ) ).to eq(
          [["d", 4], ["c", 3], ["b",2], ["a", 1]]
        )
      end

      it "finds a space occupied by an enemy to the bottom-left of the piece" do
        subject.chess_board[6][1] = opposing_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 ) ).to eq(
          [["d", 4], ["c", 3], ["b",2]]
        )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[6][1] = friendly_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, -1 ) ).to eq(
          [["d", 4], ["c", 3]]
        )
      end
    end
    
    context "when finding spaces to the bottom right" do
      it "finds all the empty spaces to the bottom-right of the piece" do
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 ) ).to eq(
          [["f", 4], ["g", 3], ["h",2]]
        )
      end

      it "finds a space occupied by an enemy to the bottom-right of the piece" do
        subject.chess_board[5][6] = opposing_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 ) ).to eq(
          [["f", 4], ["g", 3]]
        )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[5][6] = friendly_piece
        expect( subject.find_possible_diagonally_spaces( 4, 3, piece, 1, 1 ) ).to eq(
          [["f", 4]]
        )
      end
    end
  end
end