require "rails_helper"
require "previous_file_location"
require "next_file_location"

describe EnPassant::DownEnPassantMoves do
  let( :board ) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :pawn ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 4, "team" => :white, "board" => board, 
    "orientation" => :down, "capture_through_en_passant" => true } ) }
  let( :ep ) { described_class.new( pawn ) }
  
  describe "#check_for_enpassant" do
    it "returns true if pawn can perform en_passant to the previous file location" do
      allow( board ).to receive( :find_piece_on_board ).and_return pawn
      allow( pawn ).to receive( :move_counter ).and_return 1
      allow( pawn ).to receive( :can_be_captured_en_passant? ).and_return true
      expect( ep.check_for_enpassant( :previous ) ).to be_truthy
    end
    
    it "returns true if pawn can perform en_passant to the next file location" do
      allow( board ).to receive( :find_piece_on_board ).and_return pawn
      allow( pawn ).to receive( :move_counter ).and_return 1
      allow( pawn ).to receive( :can_be_captured_en_passant? ).and_return true
      expect( ep.check_for_enpassant( :next ) ).to be_truthy
    end
    
    it "returns false if pawn can NOT perform en_passant" do
      allow( board ).to receive( :find_piece_on_board ).and_return pawn
      allow( pawn ).to receive( :move_counter ).and_return 2
      
      expect( ep.check_for_enpassant( :next ) ).to be_falsey
    end
  end
  
  describe "#possible_move_input" do
    it "returns the en_passant input command" do
      expect( ep.possible_move_input( :next ) ).to eq( ["e", 4, "f", 3, "e.p." ] )
    end
  end
end