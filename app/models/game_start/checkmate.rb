#require ...
module GameStart
  class Checkmate
    attr_reader :json_board, :current_player_team, :enemy_player_team
    
    def initialize json_board, current_player_team, enemy_player_team
      @json_board = json_board
      @current_player_team = current_player_team
      @enemy_player_team = enemy_player_team
    end
    
    def find_checkmate_escape_moves
      possible_moves = []
      possible_moves.concat( CheckmateMoves::KingEscapeMoves.
        find_moves( json_board, current_player_team, enemy_player_team ) )
      possible_moves
    end
  end
end
    
    # def capture_threatening_piece
#       threatening_pieces_locations = determine_threatening_pieces_locations
#       puts threatening_pieces_locations.inspect
#     end
#
#     def determine_threatening_pieces_locations
#       enemy_pieces.map do |piece|
#         possible_piece_moves = piece.determine_possible_moves
#         if possible_piece_moves.include?( [king.position.file, king.position.rank] )
#           [piece.position.file, piece.position.rank]
#         else
#           nil
#         end
#       end.compact
#     end
#
#     def attempt_to_move_out_of_check( piece, target_file, target_rank, original_position )
#       piece.update_piece_position( target_file, target_rank )
#       piece.board.update_board( king )
#       piece.board.remove_old_position( original_position )
#     end
#
#     def track_possible_moves( piece, location, original_position )
#       possible_moves << [original_position.file, original_position.rank].
#         concat( location )
#     end
#
#     def restore_original_board_on_pieces
#       board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
#       pieces = current_player_pieces.concat( enemy_pieces )
#       pieces.each { |piece| piece.board = board }
#       insert_board_on_pieces_in_board( pieces, board )
#     end
#
#     def insert_board_on_pieces_in_board pieces, chess_board
#       pieces.each do |piece|
#         piece.board.chess_board.each do |row|
#           row.each { |location| location.board = chess_board unless location.nil? }
#         end
#       end
#     end
#   end

# def capture_piece_threatening_king( player, enemy_player )
#   enemy_pieces_collection = determine_enemy_piece_map( player, enemy_player ).keys
#   return if enemy_pieces_collection.size >= 2 # can't capture two enemy pieces in one move
#   player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
#     attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection )
#   end
# end

# def determine_enemy_piece_map( player, enemy_player )
#   enemy_piece_map = {}
#   king = player.king_piece
#   enemy_player.team_pieces.select{ |piece| !piece.captured? }.each do |piece|
#     possible_piece_moves = piece.determine_possible_moves
#     if possible_piece_moves.include?( [king.position.file, king.position.rank] )
#       enemy_piece_map[piece] = possible_piece_moves
#     end
#   end
#   enemy_piece_map
# end

# def attempt_to_capture_enemy_piece( player, enemy_player, piece, enemy_pieces_collection )
#   piece_possible_moves = piece.determine_possible_moves
#   enemy_location = [enemy_pieces_collection.first.position.file,
#                 enemy_pieces_collection.last.position.rank]
#   if piece_possible_moves.include?( enemy_location )
#     move_the_piece!( piece, enemy_location, player, enemy_player )
#     restore_captured_piece_on_board enemy_pieces_collection.first
#   end
# end