require "rails_helper"

describe PieceMovement::VerticalMovement do
  subject { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ).extend( described_class, MoveValidations::Validations ) }
  
  let(:piece) { double( team: :white) }
  let(:opposing_piece) { double( team: :black) }
  let(:friendly_piece) { double( team: :white) }
  
  describe "#find_possible_vertical_spaces" do
    context "when moving up" do
      it "finds all the empty spaces above the piece" do
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, -1 ) ).to eq( [["e", 6], ["e", 7], ["e",8]] )
      end
      
      it "finds a space occupied by an enemy above the piece" do
        subject.chess_board[1][4] = opposing_piece
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, -1 ) ).to eq( [["e", 6], ["e", 7]] )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[1][4] = friendly_piece
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, -1 ) ).to eq( [["e", 6]] )
      end
    end
  
    context "when moving down" do
      it "finds all the empty spaces below the piece" do
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, 1 ) ).to eq( [["e", 4], ["e", 3], ["e",2], ["e", 1]] )
      end

      it "finds a space occupied by an enemy below the piece" do
        subject.chess_board[5][4] = opposing_piece
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, 1 ) ).to eq( [["e", 4], ["e", 3]] )
      end

      it "does not track spaces that are occupied by a friendly piece" do
        subject.chess_board[5][4] = friendly_piece
        expect( subject.find_possible_vertical_spaces( 4, 3, piece, 1 ) ).to eq( [["e", 4]] )
      end
    end
  end
end