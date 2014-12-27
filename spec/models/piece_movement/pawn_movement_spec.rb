require "rails_helper"

describe PieceMovement::PawnMovement do
  let( :board ) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:piece) { double( position: Position.new( "f", 5 ), team: :black, orientation: :up, 
                         move_counter: 0, board: board ) }
  let(:piece2) { double( position: Position.new( "a", 8 ), team: :white, orientation: :up,
                         move_counter: 0, board: board ) }
  let(:piece5) { double( position: Position.new( "a", 3 ), team: :white, orientation: :up,
                         move_counter: 1, board: board ) }
  let(:piece3) { double( position: Position.new( "f", 1 ), team: :black, orientation: :down,
                         move_counter: 0, board: board ) }
  let(:piece4) { double( position: Position.new( "f", 5 ), team: :black, orientation: :down, 
                         move_counter: 0, board: board ) }
  let(:piece6) { double( position: Position.new( "f", 4 ), team: :black, orientation: :down, 
                         move_counter: 1, board: board ) }
                         
  subject { Board.new( board.chess_board ).extend( described_class, MoveValidations::Validations ) }
  
  describe "#move_straight_one_space?" do
    context "when moving from bottom to top" do
      it "checks if a piece can move straight" do
        expect( subject.move_straight_one_space?( piece ) ).to be_truthy
      end
      
      it "prevents the piece from moving off the board" do
        expect( subject.move_straight_one_space?( piece2 ) ).to be_falsey
      end
    end

    context "when moving from top to bottom" do
      it "checks if a piece can move straight" do
        subject.chess_board[4][5] = piece2
        expect( subject.move_straight_one_space?( piece4 ) ).to be_falsey
      end
    end

    context "when at the edge of the board" do
      it "prevents the piece from moving off the board" do
        expect( subject.move_straight_one_space?( piece3 )).to be_falsey
      end
    end
  end
  
  describe "#move_straight_two_spaces?" do
    context "when moving from bottom to top" do
      it "checks if a piece can move straight two spaces" do
        expect( subject.move_straight_two_spaces?( piece ) ).to be_truthy
      end

      it "prevents a piece from moving two spaces if already moved" do
        expect( subject.move_straight_two_spaces?( piece5 ) ).to be_falsey
      end

      it "prevents the piece from moving off the board" do
        expect( subject.move_straight_two_spaces?( piece2 ) ).to be_falsey
      end

      it "doesn't allow a player to skip through another piece" do
        subject.chess_board[2][5] = piece3
        expect( subject.move_straight_two_spaces?( piece ) ).to be_falsey
      end

      it "doesn't allow the piece to move if the space is occupied by another piece" do
        subject.chess_board[1][5] = piece3
        expect( subject.move_straight_two_spaces?( piece ) ).to be_falsey
      end
    end

    context "when moving from top to bottom" do
      it "checks if a piece can move straight two spaces" do
        expect( subject.move_straight_two_spaces?( piece4 ) ).to be_truthy
      end

      it "prevents the piece from moving off the board" do
        expect( subject.move_straight_two_spaces?( piece3 ) ).to be_falsey
      end

      it "prevents a piece from moving two spaces if already moved" do
        expect( subject.move_straight_two_spaces?( piece6 ) ).to be_falsey
      end

      it "doesn't allow a player to skip through another piece" do
        subject.chess_board[4][5] = piece2
        expect( subject.move_straight_two_spaces?( piece4 ) ).to be_falsey
      end

      it "doesn't allow the piece to move if the space is occupied by another piece" do
        subject.chess_board[5][5] = piece2
        expect( subject.move_straight_two_spaces?( piece4 ) ).to be_falsey
      end
    end
  end
  
  describe "#move_forward_diagonally?" do
    context "when moving from the bottom to top" do
      context "when the spaces are empty" do
        it "checks if a piece can move forward diagonally to the left" do
          expect( subject.move_forward_diagonally?( piece, :left ) ).to be_falsey
        end
    
        it "checks if a piece can move forward digaonally to the right" do
          expect( subject.move_forward_diagonally?( piece, :right ) ).to be_falsey
        end
      end
    
      context "when there is an enemy piece" do
        it "checks if a piece can move forward diagonally to the left" do
          subject.chess_board[2][4] = piece2
          expect( subject.move_forward_diagonally?( piece, :left ) ).to be_truthy
        end

        it "check is a piece can move forward diagonally to the right" do
          subject.chess_board[2][6] = piece2
          expect( subject.move_forward_diagonally?( piece, :right ) ).to be_truthy
        end
      end

      context "when there is a friendly piece" do
        it "checks if a piece can move forward diagonally to the left" do
          subject.chess_board[2][4] = piece3
          expect( subject.move_forward_diagonally?( piece, :left ) ).to be_falsey
        end

        it "check if a piece can move forward diagonally to the right" do
          subject.chess_board[2][6] = piece3
          expect( subject.move_forward_diagonally?( piece, :right ) ).to be_falsey
        end
      end
    end

    context "when moving from top to bottom" do
      context "when the spaces are empty" do
        it "checks if a piece can move forward diagonally to the left" do
          expect( subject.move_forward_diagonally?( piece4, :left ) ).to be_falsey
        end

        it "checks if a piece can move forward digaonally to the right" do
          expect( subject.move_forward_diagonally?( piece4, :right ) ).to be_falsey
        end
      end

      context "when there is an enemy piece" do
        it "checks if a piece can move forward diagonally to the left" do
          subject.chess_board[4][6] = piece2
          expect( subject.move_forward_diagonally?( piece4, :left ) ).to be_truthy
        end

        it "checks if a piece can move forward diagonally to the right" do
          subject.chess_board[4][4] = piece2
          expect( subject.move_forward_diagonally?( piece4, :right ) ).to be_truthy
        end
      end

      context "when there is a friendly piece" do
        it "checks if a piece can move forward diagonally to the left" do
          subject.chess_board[4][6] = piece3
          expect( subject.move_forward_diagonally?( piece4, :left ) ).to be_falsey
        end

        it "checks if a piece can move forward diagonally to the right" do
          subject.chess_board[4][4] = piece3
          expect( subject.move_forward_diagonally?( piece4, :right ) ).to be_falsey
        end
      end
    end
  end
end