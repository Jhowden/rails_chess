require "rails_helper"

describe EnPassant::EnPassantMoves do
  let( :pawn ) { GamePieces::Pawn.new( { file: "h", rank: 4, team: :black, 
    orientation: :down, capture_through_en_passant: true } ) }
  let( :ep ) { described_class.new( pawn ) }
  let( :position ) { Position.new( "a", 4 ) }
  
  before :each do
    stub_const( "FileCheckerFactory", Class.new )
    allow( FileCheckerFactory ).to receive( :create_for ).and_return -1
  end
  
  describe "#legal_to_perform_en_passant?" do
    it "returns true if an enemy_pawn can be captured through en_passant" do
      allow( pawn ).to receive( :move_counter ).and_return 1
      expect( ep.legal_to_perform_en_passant?( pawn ) ).to be_truthy
    end
    
    it "returns false if an enemy pawn can NOT be captured through en_passant" do
      allow( pawn ).to receive( :move_counter ).and_return 2
      expect( ep.legal_to_perform_en_passant?( pawn ) ).to be_falsey
    end
  end
  
  describe "#is_legal_move?" do
    it "returns false if it is a legal move" do
     ep.is_legal_move?( position, :previous )
     expect( FileCheckerFactory ).to have_received( :create_for ).with( position, :previous )
    end
  end
end