require "rails_helper"

#move this out of here and into board.rb

describe MoveValidations do
  subject { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ).extend( described_class ) }
  let(:piece) { double( position: Position.new( "e", 4 ), team: :black ) }
  let(:piece2) { double( position: Position.new( "f", 4 ), team: :black ) }
  
  describe "#valid_space?" do
    it "determines if a space can be occupied" do
      expect( subject.valid_space?( 3, 2, piece ) ).to be_truthy
    end
    
    it "determines if a space cannot be occupied" do
      subject.chess_board[2][3] = piece2
      expect( subject.valid_space?( 3, 2, piece ) ).to be_falsey
    end
  end
  
  describe "#legal_move?" do
    it "detects if a piece is trying to be placed off the board" do
      expect( subject.legal_move?( 4, 6 ) ).to be_truthy
      expect( subject.legal_move?( 5, 8 ) ).to be_falsey
      expect( subject.legal_move?( 8, 0 ) ).to be_falsey
    end
  end
end