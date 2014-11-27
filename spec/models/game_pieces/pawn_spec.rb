require "rails_helper"

describe GamePieces::Pawn do
  let(:board) { double( "board", chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let(:pawn) { described_class.new( { "file" => "b", "rank" => 2, "team" => "black", "board" => board, 
    "orientation" => "up", "capture_through_en_passant" => true } ) }
  let(:pawn2) { described_class.new( { "file" => "d", "rank" => 5, "team" => "white", "board" => board, 
    "orientation" => "down", "capture_through_en_passant" => true } ) }
  
  before :each do
    allow( board ).to receive( :move_straight_one_space? )
    allow( board ).to receive( :move_straight_two_spaces? )
    allow( board ).to receive( :move_forward_diagonally? )
    allow( board ).to receive( :find_piece_on_board )
  end

  describe "#determine_possible_moves" do
    context "when there are no diagonal enemies and no forward blockers" do
      
      it "asks the board if it can move one space" do
        pawn.determine_possible_moves
        
        expect( board ).to have_received( :move_straight_one_space?)
      end
      
      it "asks the board if it can move two spaces" do
        pawn.determine_possible_moves
        
        expect( board ).to have_received( :move_straight_two_spaces?)
      end
      
      it "has two possible moves when pawn facing up" do
        allow( board ).to receive( :move_straight_one_space? ).and_return( true )
        allow( board ).to receive( :move_straight_two_spaces? ).and_return( true )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves ).to eq( [["b", 3], ["b", 4]] )
      end
      
      it "has two possible moves when pawn facing down" do
        allow( board ).to receive( :move_straight_one_space? ).and_return( true )
        allow( board ).to receive( :move_straight_two_spaces? ).and_return( true )
    
        pawn2.determine_possible_moves
        expect( pawn2.possible_moves ).to eq( [["d", 4], ["d", 3]] )
      end
    end

    context "when there are diagonal enemies and forward blockers" do 
      context "when pawn is going up" do        
        it "returns only two possible moves when diagonal right" do
          allow( board ).to receive( :move_straight_one_space? ).and_return( true )
          allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( true )
    
          pawn.determine_possible_moves
          expect( pawn.possible_moves ).to eq( [["b", 3], ["c", 3]] )
        end
      
        it "returns only two possible moves when diagonal left" do
          allow( board ).to receive( :move_straight_one_space? ).and_return( true )
          allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( true )
    
          pawn.determine_possible_moves
          expect( pawn.possible_moves ).to eq( [["b", 3], ["a", 3]] )
        end
      end
      
      context "when pawn is going down" do        
        it "returns only two possible moves when diagonal right" do
          allow( board ).to receive( :move_straight_one_space? ).and_return( true )
          allow( board ).to receive( :move_forward_diagonally? ).with( pawn2, :right ).and_return( true )
    
          pawn2.determine_possible_moves
          expect( pawn2.possible_moves ).to eq( [["d", 4], ["c", 4]] )
        end
      
        it "returns only two possible moves when diagonal left" do
          allow( board ).to receive( :move_straight_one_space? ).and_return( true )
          allow( board ).to receive( :move_forward_diagonally? ).with( pawn2, :left ).and_return( true )
    
          pawn2.determine_possible_moves
          expect( pawn2.possible_moves ).to eq( [["d", 4], ["e", 4]] )
        end
      end
      
      context "when on the edge of the board" do
        it "returns no possible moves" do 
          allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( false )
          allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )   
          pawn.determine_possible_moves
          expect( pawn.possible_moves ).to eq( [] )
        end
      end
    end
  
    context "when there is a diagonal friendly" do
      it "returns no possible moves" do
        allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :left ).and_return( false )
        allow( board ).to receive( :move_forward_diagonally? ).with( pawn, :right ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves ).to eq( [] )
      end
    end
  
    context "when there is a piece straight ahead" do
      it "returns no possible moves" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( false )
        allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves ).to eq( [] )
      end
    end

    context "when there is a piece two spots ahead" do
      it "returns one possible move" do
        allow( board ).to receive( :move_straight_one_space? ).with( pawn ).and_return( true )
        allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( false )
    
        pawn.determine_possible_moves
        expect( pawn.possible_moves ).to eq( [["b", 3]] )
      end
    end
    
    context "when en passant" do
      before :each do
        stub_const( "EnPassantCommands", Class.new )
        allow( EnPassantCommands ).to receive( :can_en_passant? )
        allow( EnPassantCommands ).to receive( :capture_pawn_en_passant! )
      end

      it "checks to see if the pawn can perform en passant to the left" do
        pawn.determine_possible_moves

        expect( EnPassantCommands ).to have_received( :can_en_passant? ).with( pawn, :previous )
      end

      it "checks to see if the pawn can perform en passant to the right" do
        pawn.determine_possible_moves

        expect( EnPassantCommands ).to have_received( :can_en_passant? ).with( pawn, :next )
      end

      it "returns the possible move for en_passant" do
        allow( EnPassantCommands ).to receive( :can_en_passant? ).and_return( true, false )
        allow( EnPassantCommands ).to receive( :capture_pawn_en_passant! ).and_return( ["d", 3, "e.p."] )

        pawn.determine_possible_moves

        expect( pawn.possible_moves ).to eq( [["d", 3, "e.p."]] )
      end

      it "does not return any en_passant moves when pawn can't en_passant" do
        allow( EnPassantCommands ).to receive( :can_en_passant? ).and_return( false, false )

        pawn.determine_possible_moves

        expect( pawn.possible_moves ).to eq []
      end
    end

    it "clears possible moves when not empty" do
      pawn.possible_moves << ["a", 3]
      allow( board ).to receive( :move_straight_one_space? ).and_return( true )
      allow( board ).to receive( :move_straight_two_spaces? ).with( pawn ).and_return( true )
      pawn.determine_possible_moves
      expect( pawn.possible_moves ).to eq( [["b", 3], ["b", 4]] )
    end
  end

  context "when a black piece" do
    it "displays the correct board marker" do
      expect( pawn.board_marker ).to eq( "♟" )
    end
  end

  context "when a white piece" do
    it "displays the correct board marker" do
      expect( pawn2.board_marker ).to eq( "♙" )
    end
  end
  
  describe "update_en_passant!" do
    it "updates the status of the pawn's en_passant" do
      pawn.update_en_passant_status!
      expect( pawn.capture_through_en_passant ).to be_falsey
    end
  end

  describe "#can_be_captured_en_passant?" do
    it "returns true if the pawn can be captured through en passant" do
      expect( pawn.can_be_captured_en_passant? ).to be_truthy
    end
    
    it "returns false if the pawn can't be captured through en passant" do
      pawn.update_en_passant_status!
      expect( pawn.can_be_captured_en_passant? ).to be_falsey
    end
  end
  
  describe "new_file_position" do
    it "returns the previous file position" do
      expect( pawn.new_file_position( :previous ) ).to eq "a"
    end
    
    it "returns the next file position" do
      expect( pawn.new_file_position( :next ) ).to eq "c"
    end
  end
end