require "rails_helper"

describe PiecesFactory do

  let(:en_passant) { double() }
  let(:white_pieces_factory) { described_class.new( :white, en_passant ) }
  let(:black_pieces_factory) { described_class.new( :black, en_passant ) }

  describe "#build" do
    it "creates the 16 pieces" do
      white_pieces_factory.build
      expect( white_pieces_factory.pieces.size ).to eq( 16 )
    end
    
    it "creates the 16 black pieces" do
      black_pieces_factory.build
      expect( black_pieces_factory.pieces.size ).to eq( 16 )
    end
    
    context "when white team" do
      before( :each ) do
        white_pieces_factory.build
        @pawn_collection = white_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Pawn }
      end
      
      it "creates 8 pawns" do
        expect( @pawn_collection.size ).to eq 8
      end

      it "creates a pawn with the correct board marker" do
        expect( @pawn_collection.first.board_marker ).to eq( "♙" )
      end
  
      it "creates a pawn with the correct team" do
        expect( @pawn_collection.all?{ |pawn| pawn.team == :white } ).to be_truthy
      end

      it "creates a pawn with the correct board" do
        expect( @pawn_collection.all?{ |pawn| pawn.board.nil? } ).to be_truthy
      end

      it "creates a pawn with the correct orientation" do
        expect( @pawn_collection.all?{ |pawn| pawn.orientation == :down } ).to be_truthy
      end

      it "creates a pawn with an en_passant object" do
        expect( @pawn_collection.all?{ |pawn| pawn.en_passant == en_passant } ).to be_truthy
      end
    end

    context "when black team" do
      before( :each ) do
        black_pieces_factory.build
        @pawn_collection = black_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Pawn }
      end
      
      it "creates 8 pawns" do
        expect( @pawn_collection.size ).to eq 8
      end
      
      it "creates a pawn with the correct board marker" do
        expect( @pawn_collection.first.board_marker ).to eq( "♟" )
      end
      
      it "creates a pawn with the correct team" do
        expect( @pawn_collection.all?{ |pawn| pawn.team == :black } ).to be_truthy
      end
      
      it "creates a pawn with the correct board" do
        expect( @pawn_collection.all?{ |pawn| pawn.board.nil? } ).to be_truthy
      end
      
      it "creates a pawn with the correct orientation" do
        expect( @pawn_collection.all?{ |pawn| pawn.orientation == :up } ).to be_truthy
      end
      
      it "creates a pawn with an en_passant object" do
        expect( @pawn_collection.all?{ |pawn| pawn.en_passant == en_passant } ).to be_truthy
      end
    end
    
    context "when white team" do
      before( :each ) do
        white_pieces_factory.build
        @rook_collection = white_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Rook}
      end

      it "creates the white rooks" do
        expect( @rook_collection.size ).to eq( 2 )
      end

      it "creates a rook with the correct board marker" do
        expect( @rook_collection.first.board_marker ).to eq( "♖" )
      end

      it "creates a rook with the correct file" do
        expect( @rook_collection.any?{ |rook| rook.position.file == "a" } ).to be_truthy
      end

      it "creates a rook with the correct rank" do
        expect( @rook_collection.all?{ |rook| rook.position.rank == 8 } ).to be_truthy
      end

      it "creates a rook with the correct team" do
        expect( @rook_collection.all?{ |rook| rook.team == :white } ).to be_truthy
      end

      it "creates a rook with the correct board" do
        expect( @rook_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
      end
    end

    context "when black team" do
      before( :each ) do
        black_pieces_factory.build
        @rook_collection = black_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Rook}
      end

      it "creates the black rooks" do
        expect( @rook_collection.size ).to eq( 2 )
      end

      it "creates a rook with the correct board marker" do
        expect( @rook_collection.first.board_marker ).to eq( "♜" )
      end

      it "creates a rook with the correct file" do
        expect( @rook_collection.any?{ |rook| rook.position.file == "a" } ).to be_truthy
      end

      it "creates a rook with the correct rank" do
       expect( @rook_collection.all?{ |rook| rook.position.rank == 1 } ).to be_truthy
      end

      it "creates a rook with the correct team" do
        expect( @rook_collection.all?{ |rook| rook.team == :black } ).to be_truthy
      end

      it "creates a rook with the correct board" do
        expect( @rook_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
      end
    end
  end
  
  context "when white team" do
    before( :each ) do
      white_pieces_factory.build
      @bishop_collection = white_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Bishop}
    end

    it "creates the white bishops" do
      expect( @bishop_collection.size ).to eq( 2 )
    end

    it "creates a bishop with the correct board marker" do
      expect( @bishop_collection.first.board_marker ).to eq( "♗" )
    end

    it "creates a bishop with the correct file" do
      expect( @bishop_collection.any?{ |rook| rook.position.file == "c" } ).to be_truthy
    end

    it "creates a bishop with the correct rank" do
      expect( @bishop_collection.all?{ |rook| rook.position.rank == 8 } ).to be_truthy
    end

    it "creates a bishop with the correct team" do
      expect( @bishop_collection.all?{ |rook| rook.team == :white } ).to be_truthy
    end

    it "creates a bishop with the correct board" do
      expect( @bishop_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
    end
  end

  context "when black team" do
    before( :each ) do
      black_pieces_factory.build
      @bishop_collection = black_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Bishop}
    end

    it "creates the black bishops" do
      expect( @bishop_collection.size ).to eq( 2 )
    end

    it "creates a bishop with the correct board marker" do
      expect( @bishop_collection.first.board_marker ).to eq( "♝" )
    end

    it "creates a bishop with the correct file" do
      expect( @bishop_collection.any?{ |rook| rook.position.file == "c" } ).to be_truthy
    end

    it "creates a bishop with the correct rank" do
      expect( @bishop_collection.all?{ |rook| rook.position.rank == 1 } ).to be_truthy
    end

    it "creates a bishop with the correct team" do
      expect( @bishop_collection.all?{ |rook| rook.team == :black } ).to be_truthy
    end

    it "creates a bishop with the correct board" do
      expect( @bishop_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
    end
  end

  context "when white team" do
    before( :each ) do
      white_pieces_factory.build
      @knight_collection = white_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Knight}
    end

    it "creates the white knights" do
     expect( @knight_collection.size ).to eq( 2 )
    end

    it "creates a knight with the correct board marker" do
       expect( @knight_collection.first.board_marker ).to eq( "♘" )
    end

    it "creates a knight with the correct file" do
      expect( @knight_collection.any?{ |rook| rook.position.file == "b" } ).to be_truthy
    end

    it "creates a knight with the correct rank" do
      expect( @knight_collection.all?{ |rook| rook.position.rank == 8 } ).to be_truthy
    end

    it "creates a knight with the correct team" do
      expect( @knight_collection.all?{ |rook| rook.team == :white } ).to be_truthy
    end

    it "creates a knight with the correct board" do
      expect( @knight_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
    end
  end

  context "when black team" do
    before( :each ) do
      black_pieces_factory.build
      @knight_collection = black_pieces_factory.pieces.
          select{ |piece| piece.class == GamePieces::Knight}
    end

    it "creates the black knights" do
      expect( @knight_collection.size ).to eq( 2 )
    end

    it "creates a knight with the correct board marker" do
      expect( @knight_collection.first.board_marker ).to eq( "♞" )
    end

    it "creates a knight with the correct file" do
      expect( @knight_collection.any?{ |rook| rook.position.file == "b" } ).to be_truthy
    end

    it "creates a knight with the correct rank" do
      expect( @knight_collection.all?{ |rook| rook.position.rank == 1 } ).to be_truthy
    end

    it "creates a knight with the correct team" do
      expect( @knight_collection.all?{ |rook| rook.team == :black } ).to be_truthy
    end

    it "creates a knight with the correct board" do
      expect( @knight_collection.all?{ |rook| rook.board.nil? } ).to be_truthy
    end
  end

  context "when white team" do
    before( :each ) do
      white_pieces_factory.build
      @queen = white_pieces_factory.pieces.find{ |piece| piece.class == GamePieces::Queen }
    end

    it "creates the white queen" do
      queen = white_pieces_factory.pieces.select{ |piece| piece.class == GamePieces::Queen }
      expect( queen.size ).to eq( 1 )
    end

    it "creates a queen with the correct board marker" do
      expect( @queen.board_marker ).to eq( "♕" )
    end

    it "creates a queen with the correct file" do
      expect( @queen.position.file ).to eq( "d" )
    end

    it "creates a queen with the correct rank" do
      expect( @queen.position.rank ).to eq( 8 )
    end

    it "creates a queen with the correct team" do
      expect( @queen.team ).to eq( :white )
    end

    it "creates a queen with the correct board" do
      expect( @queen.board ).to be_nil
    end
  end
#
  context "when black team" do
    before( :each ) do
      black_pieces_factory.build
      @queen = black_pieces_factory.pieces.find{ |piece| piece.class == GamePieces::Queen }
    end

    it "creates the black queen" do
      queen = black_pieces_factory.pieces.select{ |piece| piece.class == GamePieces::Queen }
      expect( queen.size ).to eq( 1 )
    end

    it "creates a queen with the correct board marker" do
      expect( @queen.board_marker ).to eq( "♛" )
    end

    it "creates a queen with the correct file" do
      expect( @queen.position.file ).to eq( "d" )
    end

    it "creates a queen with the correct rank" do
      expect( @queen.position.rank ).to eq( 1 )
    end

    it "creates a queen with the correct team" do
      expect( @queen.team ).to eq( :black )
    end

    it "creates a queen with the correct board" do
      expect( @queen.board ).to be_nil
    end
  end

  context "when white team" do
    before( :each ) do
      white_pieces_factory.build
      @king = white_pieces_factory.pieces.find{ |piece| piece.class == GamePieces::King }
    end

    it "creates the white king queen" do
      king = white_pieces_factory.pieces.select{ |piece| piece.class == GamePieces::King }
      expect( king.size ).to eq( 1 )
    end

    it "creates a king with the correct board marker" do
      expect( @king.board_marker ).to eq( "♔" )
    end

    it "creates a king with the correct file" do
      expect( @king.position.file ).to eq( "e" )
    end

    it "creates a king with the correct rank" do
      expect( @king.position.rank ).to eq( 8 )
    end

    it "creates a king with the correct team" do
      expect( @king.team ).to eq( :white )
    end

    it "creates a king with the correct board" do
      expect( @king.board ).to be_nil
    end
  end

    context "when black team" do
      before( :each ) do
        black_pieces_factory.build
        @king = black_pieces_factory.pieces.find{ |piece| piece.class == GamePieces::King }
      end

      it "creates the black king queen" do
        king = black_pieces_factory.pieces.select{ |piece| piece.class == GamePieces::King }
        expect( king.size ).to eq( 1 )
      end

      it "creates a king with the correct board marker" do
        expect( @king.board_marker ).to eq( "♚" )
      end

      it "creates a king with the correct file" do
        expect( @king.position.file ).to eq( "e" )
      end

      it "creates a king with the correct rank" do
        expect( @king.position.rank ).to eq( 1 )
      end

      it "creates a king with the correct team" do
        expect( @king.team ).to eq( :black )
      end

      it "creates a king with the correct board" do
        expect( @king.board ).to be_nil
      end
    end
end