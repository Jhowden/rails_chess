require "en_passant/en_passant_orientation_factory"
require "en_passant/captured_piece_en_passant_team_identifier"

module EnPassantCommands
  def self.can_en_passant?( pawn, navigation )
    pawn_en_passant = EnPassant::EnPassantOrientationFactory.for_orientation( pawn )
    pawn_en_passant.check_for_enpassant( navigation )
  end
  
  def self.capture_pawn_en_passant!( pawn, navigation )
    pawn_en_passant = EnPassant::EnPassantOrientationFactory.for_orientation( pawn )
    pawn_en_passant.possible_move_input( navigation )
  end
  
  def self.update_enemy_pawn_status_for_en_passant( enemy_pieces, team )
    pieces = EnPassant::CapturedPieceEnPassantTeamIdentifier.select_pieces( enemy_pieces, team )
    pieces.each { |piece| piece.update_en_passant_status! }
  end
end