require 'rails_helper'

describe Board do
  let( :board ) { described_class.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :piece ) { double( position: Position.new( "f", 5 ), "team" => :black, "orientation" => :up, 
                        move_counter: 0 ) }
  let( :piece2 ) { double( position: Position.new( "a", 8 ), "team" => :white, "orientation" => :up,
                        move_counter: 1 ) }
  let( :rook ) { GamePieces::Rook.new( { "file" => "a", "rank" => 8, "team" => :white, "captured" => false } ) }
  let( :bishop ) { GamePieces::Bishop.new( { "file" => "b", "rank" => 1, "team" => :black, "captured" => false } ) }
  let( :pawn ) { GamePieces::Pawn.new( { "file" => "b", "rank" => 2, "team" => :black, 
    "orientation" => :up, "capture_through_en_passant" => true, "captured" => false } ) }
  let( :king ) { GamePieces::King.new( { "file" => "a", "rank" => 7, "team" => :white,
    "captured" => false, "checkmate" => false } ) }
  let( :knight ) { GamePieces::Knight.new( { "file" => "d", "rank" => 5, "team" => :black, "captured" => false } ) }
  let( :pieces ) { [rook, pawn, bishop, king] }
  
  before :each do
    stub_const( "PiecesFactory", Class.new )
    allow( PiecesFactory ).to receive( :new ).and_return PiecesFactory
    allow( PiecesFactory ).to receive( :build ).and_return pieces
    
    stub_const( "NullObject::NullPiece", Class.new )
    allow( NullObject::NullPiece ).to receive( :new )
  end
  
  describe "#update_board" do
    context "when a space is occupied" do
      it "removes and replaces the opposing piece with new piece" do
        board.chess_board[3][5] = piece2
        allow( piece2 ).to receive( :captured! )
        board.update_board( piece )
        expect( board.chess_board[3][5] ).to eq( piece )
      end
      
      it "captures the piece occuping the spot" do
        board.chess_board[3][5] = piece2
        expect( piece2 ).to receive( :captured! )
        board.update_board( piece )
      end
    end
    
    context "when a space is open" do
      it "places the piece in the cell" do
        board.update_board( piece )
        expect( board.chess_board[3][5] ).to eq( piece )
      end
    end
  end
  
  describe "#place_pieces_on_board" do
    it "sets the team for the PiecesFactory" do
      board.place_pieces_on_board

      expect( PiecesFactory ).to have_received( :new ).with( :white )
      expect( PiecesFactory ).to have_received( :new ).with( :black )
    end
    
    it "builds the pieces" do
      board.place_pieces_on_board
      
      expect( PiecesFactory ).to have_received( :build ).exactly( :twice )
    end
    
    it "sets the pieces on the board" do
      board.place_pieces_on_board
      
      expect( board.chess_board[0][0] ).to be_an_instance_of GamePieces::Rook
      expect( board.chess_board[7][1] ).to be_an_instance_of GamePieces::Bishop
      expect( board.chess_board[6][1] ).to be_an_instance_of GamePieces::Pawn
      expect( board.chess_board[1][0] ).to be_an_instance_of GamePieces::King
    end
  end
  
  describe "#find_piece_on_board" do
    context "when a piece is found" do
      it "finds the piece on the board" do
        board.chess_board[3][5] = piece
        expect( board.find_piece_on_board( piece.position ) ).to eq piece
      end
    end

    context "when not finding a piece" do
      it "returns a NullPiece object" do
        board.find_piece_on_board( piece.position )
        expect( NullObject::NullPiece ).to have_received( :new )
      end
    end
  end
  
  describe "#remove_old_position" do
    it "removes a pieces marker" do
      board.chess_board[3][5] = piece
      board.remove_old_position( Position.new( "f", 5 ) )
      expect( board.chess_board[3][5] ).to be_nil
    end
  end
  
  describe "#convert_to_file_position" do
    it "converts an index into a file position" do
      expect( board.convert_to_file_position( 0 ) ).to eq( "a" )
    end
  end
  
  describe "#convert_to_rank_position" do
    it "converts an index into a rank position" do
      expect( board.convert_to_rank_position( 5 ) ).to eq( 3 )
    end
  end
  
  describe "#find_vertical_spaces" do
    context "when there are no other pieces in the same column" do
      it "return an array of possible moves" do
        board.find_vertical_spaces( piece )
        expect( board.possible_moves ).to eq( 
          [["f", 6], ["f", 7], ["f", 8], ["f",4], ["f", 3], ["f", 2], ["f", 1]]
        )
      end
    end
    
    context "when there is an enemy in the same column" do
      it "returns an array of possible moves with that space included and not any others past it" do
        board.chess_board[2][5] = piece2
        board.find_vertical_spaces( piece )
        expect( board.possible_moves ).to eq( [["f", 6], ["f",4], ["f", 3], ["f", 2], ["f", 1]] )
      end
    end

    context "when there is a friendly piece in the same row" do
      it "returns an array not including that space or any more after it" do
        board.chess_board[1][5] = bishop
        board.find_vertical_spaces( piece )
        expect( board.possible_moves ).to eq( [["f", 6], ["f",4], ["f", 3], ["f", 2], ["f", 1]] )
      end
    end
  end
  
  describe "#find_horizontal_spaces" do
    context "when there are no other pieces in the same row" do
      it "returns an array of possible moves" do
        board.find_horizontal_spaces( piece )
        expect( board.possible_moves ).to eq( 
          [["e", 5], ["d", 5], ["c", 5], ["b", 5], ["a", 5], ["g", 5], ["h", 5]]
        )
      end
    end
    
    context "when there is an enemy in the same row" do
      it "returns an array of possible moves with enemy space included and not any others past it" do
        board.chess_board[3][2] = piece2
        board.find_horizontal_spaces( piece )
        expect( board.possible_moves ).to eq( [["e", 5], ["d", 5], ["c", 5], ["g", 5], ["h", 5]] )
        end
    end

    context "when there is a friendly piece in the same row" do
      it "returns an array not including that space or any more after it" do
        board.chess_board[3][2] = bishop
        board.find_horizontal_spaces( piece )
        expect( board.possible_moves ).to eq( [["e", 5], ["d", 5], ["g", 5], ["h", 5]] )
      end
    end
  end
  
  describe "#find_diagonal_spaces" do
    context "when there are no other pieces diagonally" do
      it "returns an array of possible moves" do
        board.find_diagonal_spaces( piece )
        expect( board.possible_moves ).to eq( 
          [
            ["e", 6], ["d", 7], ["c", 8],
            ["g", 6], ["h", 7],
            ["e", 4], ["d", 3], ["c", 2], ["b", 1],
            ["g", 4], ["h", 3]
          ] 
        )
      end
    end
    
    context "when there is an enemy in a diagonal space" do
      it "returns an array of possible moves with that space included but not any others past it" do
        board.chess_board[4][6] = piece2
        board.chess_board[2][4] = piece2
        board.find_diagonal_spaces( piece )
        expect( board.possible_moves ).to eq(
          [
            ["e", 6],
            ["g", 6], ["h", 7],
            ["e", 4], ["d", 3], ["c", 2], ["b", 1],
            ["g", 4]
          ]
        )
      end
    end

    context "when there is a friendly piece in the same diagonal space" do
      it "returns an array excluding that space or any more after it" do
        board.chess_board[4][6] = bishop
        board.chess_board[2][4] = bishop
        board.chess_board[4][4] = bishop
        board.find_diagonal_spaces( piece )
        expect( board.possible_moves ).to eq(
          [["g", 6], ["h", 7]]
        )
      end
    end
    
    describe "#find_knight_spaces" do
      context "when there are no surrounding pieces" do
        it "returns an array of all possible moves" do
          expect( board.find_knight_spaces( knight ) ).to eq(
            [
              ["c", 7], ["b", 6],
              ["e", 7], ["f", 6],
              ["c", 3], ["b", 4],
              ["e", 3], ["f", 4]
            ]
          )
        end
      end

      context "when there are surrounding enemy pieces" do
        it "returns an array of possibles moves with those space included" do
          board.chess_board[1][4] = piece2
          board.chess_board[4][1] = piece2
          expect( board.find_knight_spaces( knight ) ).to eq(
            [
              ["c", 7], ["b", 6],
              ["e", 7], ["f", 6],
              ["c", 3], ["b", 4],
              ["e", 3], ["f", 4]
            ]
          )
        end
      end

      context "when there are surrounding friendly pieces" do
        it "returns an array not including that space" do
          board.chess_board[1][4] = bishop
          board.chess_board[4][1] = bishop
          expect( board.find_knight_spaces( knight ) ).to eq(
            [
              ["c", 7], ["b", 6],
              ["f", 6],
              ["c", 3],
              ["e", 3], ["f", 4]
            ]
          )
        end
      end
    end
  
    describe "#find_king_spaces" do
      context "when there are no surrounding pieces" do
        it "returns an array of all possible moves" do
          expect( board.find_king_spaces( king ) ).to eq(
            [
              ["a", 8], ["b", 8], ["b", 7], ["b", 6], ["a", 6]
            ]
          )
        end
      end

      context "when there are surrounding enemy pieces" do
        it "returns an array of possible moves with those spaces included" do
          board.chess_board[0][0] = bishop
          expect( board.find_king_spaces( king ) ).to eq(
            [
              ["a", 8], ["b", 8], ["b", 7], ["b", 6], ["a", 6]
            ]
          )
        end
      end
 
      context "when there are surrounding enemy pieces" do
        it "returns an array of possible moves not including those spaces" do
          board.chess_board[0][0] = piece2
          expect( board.find_king_spaces( king ) ).to eq(
            [
              ["b", 8], ["b", 7], ["b", 6], ["a", 6]
            ]
          )
        end
      end
    end
  end
end