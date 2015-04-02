require "board_json_parser"
require "find_pieces/find_team_pieces"
require "en_passant_commands"

module MoveSequence
  class StandardKingInCheckSequence
    attr_reader :escape_moves, :input, :players_info, :board
    
    def initialize( escape_moves, input, players_info )
      @escape_moves = escape_moves
      @input = input
      @players_info = players_info
      @board = Board.new( BoardJsonParser.
        parse_json_board( players_info.json_board ) )
    end
    
    def valid_move?()
      return false unless escape_moves.include? input.chess_notation
      piece_position, target_position = find_piece_positions
      piece = board.find_piece_on_board piece_position
      if piece.team == players_info.current_team
        piece.update_piece_position target_position
        board.update_board piece
        board.remove_old_position piece_position
        piece.increase_move_counter!
        EnPassantCommands.update_enemy_pawn_status_for_en_passant(
          FindPieces::FindTeamPieces.
            find_pieces(
            players_info.enemy_team,
            board ),
          players_info.enemy_team )
        king_not_in_check?( board )
      end
    end
    
    def response()
      return board, "Successful move: #{input.chess_notation}"
    end
    
    private
    
    def find_piece_positions()
      piece_position = Position.new(
        input.piece_file,
        input.piece_rank.to_i 
      )
      enemy_position = Position.new(
        input.target_file,
        input.target_rank.to_i
      )

      return piece_position, enemy_position
    end
    
    def king_not_in_check?( updated_board )
      !GameStart::Check.king_in_check?( 
        FindPieces::FindTeamPieces.
          find_king_piece( 
            players_info.current_team, 
            updated_board ),
        FindPieces::FindTeamPieces.
          find_pieces( 
          players_info.enemy_team, 
          updated_board ) 
      )
    end
  end
end