require "rails_helper"

describe EnPassantCommands do
  let( :board ) { double( chess_board: Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :pawn ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 4, "team" => :black, "board" => board, 
    "orientation" => :down, "capture_through_en_passant" => true } ).extend described_class }
  let( :pawn2 ) { GamePieces::Pawn.new( { "file" => "e", "rank" => 5, "team" => :white, "board" => board,
    "orientation" => :up, "capture_through_en_passant" => true } ).extend described_class }
  let( :pawn_ep ) { double( "pawn_ep" ) }
    
  before :each do
    stub_const( "EnPassant::EnPassantOrientationFactory", Class.new )
    allow( EnPassant::EnPassantOrientationFactory ).to receive( :for_orientation ).and_return pawn_ep
    allow( pawn_ep ).to receive( :check_for_enpassant )
    allow( pawn_ep ).to receive( :possible_move_input )
    
    stub_const( "EnPassant::CapturedPieceEnPassantTeamIdentifier", Class.new )
    allow( EnPassant::CapturedPieceEnPassantTeamIdentifier ).to receive( :select_pieces ).and_return [pawn2]
    
    allow( pawn2 ).to receive( :update_en_passant_status! )
  end
  
  describe ".can_en_passant?" do
    it "sets the correct en_passant moves through EnPassant::EnPassantOrientationFactory" do
      described_class.can_en_passant?( pawn, :previous )
      expect( EnPassant::EnPassantOrientationFactory ).to have_received( :for_orientation ).with( pawn )
    end
    
    it "checks to see if pawn can be perform en_passant" do
      described_class.can_en_passant?( pawn, :previous )
      expect( pawn_ep ).to have_received( :check_for_enpassant ).with :previous
    end
  end
  
  describe ".capture_pawn_en_passant!" do
    it "sets the correct en_passant moves through EnPassant::EnPassantOrientationFactory" do
      described_class.capture_pawn_en_passant!( pawn, :next )
      expect( EnPassant::EnPassantOrientationFactory ).to have_received( :for_orientation ).with( pawn )
    end
    
    it "returns the command for enemy_pawn to be captured en_passant" do
      described_class.capture_pawn_en_passant!( pawn, :next )
      expect( pawn_ep ).to have_received( :possible_move_input ).with :next 
    end
  end
  
  describe ".update_enemy_pawn_status_for_en_passant" do
    it "identifies the enemy pawn's team" do
      described_class.update_enemy_pawn_status_for_en_passant( [pawn, pawn2], :black )
      expect( EnPassant::CapturedPieceEnPassantTeamIdentifier ).to have_received( :select_pieces )
    end
    
    it "updates the pawns en_passant_status" do
      described_class.update_enemy_pawn_status_for_en_passant( [pawn, pawn2], :black )
      expect( pawn2 ).to have_received( :update_en_passant_status! )
    end
  end
end
