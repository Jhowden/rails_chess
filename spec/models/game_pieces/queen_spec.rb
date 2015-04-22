require "rails_helper"

describe GamePieces::Queen do

  let(:board) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:queen) { described_class.new( { "file" => "e", "rank" => 4, "team" => :black, "board" => board } ) }
  let(:queen2) { described_class.new( { "file" => "e", "rank" => 4, "team" => :white, "board" => board } ) }

  describe "#determine_possible_moves" do
    it "returns an array of possible locations" do
      expect( board ).to receive( :find_horizontal_spaces ).with( queen ).
        and_return( [[3, 4], [4, 3], [5, 3]] )
      expect( board ).to receive( :find_vertical_spaces ).with( queen ).
        and_return( [[3, 5]] )
      expect( board ).to receive( :find_diagonal_spaces ).with( queen ).
        and_return( [[5, 4], [4, 5]] )
      queen.determine_possible_moves
      expect( queen.possible_moves.size ).to eq( 6 )
    end

    it "clears possible moves when not empty" do
      queen.possible_moves << ["a", 3]
      allow( board ).to receive( :find_diagonal_spaces ).with( queen ).
        and_return( [["d", 3]] )
      allow( board ).to receive( :find_horizontal_spaces ).with( queen ).
        and_return( [["c", 2]] )
      allow( board ).to receive( :find_vertical_spaces ).with( queen ).
        and_return( [["e", 5], ["e", 6]] )
      queen.determine_possible_moves
      expect( queen.possible_moves ).to eq( 
        [["e", 4, "c", 2],  
         ["e", 4, "e", 5],
         ["e", 4, "e", 6],
         ["e", 4, "d", 3]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( queen.board_marker ).to eq( "♛" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( queen2.board_marker ).to eq( "♕" )
    end
  end
end