module MoveSequence
  class EnPassantCheckSequence
    attr_reader :escape_moves, :input, :players_info, :board
    
    WHITE_EN_PASSANT_RANK = 1
    BLACK_EN_PASSANT_RANK = -1
    
    def initialize( escape_moves, input_type, players_info )
      @escape_moves = escape_moves
      @input = input_type.input
      @players_info = players_info
      @board = Board.new( BoardJsonParser.
        parse_json_board( players_info.json_board ) )
    end
    
    def valid_move?()
      return false unless escape_moves.include? transformed_input
      piece_position, enemy_pawn, target_position = find_piece_positions
      piece = board.find_piece_on_board piece_position
      if piece.team == players_info.current_team
        piece.update_piece_position target_position
        board.update_board piece
        board.remove_old_position piece_position
        board.remove_old_position enemy_pawn
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
      return board, "Successful move: #{transformed_input}"
    end
    
    private
    
    def transformed_input()
      piece = input["piece_location"]["file"] + input["piece_location"]["rank"]
      target = input["target_location"]["file"] + input["target_location"]["rank"]
      
      
      piece + target + input["en_passant"]
    end
    
    def find_piece_positions()
      piece_position = Position.new(
        input["piece_location"]["file"],
        input["piece_location"]["rank"].to_i 
      )
      
      target_file, target_rank = [
        input["target_location"]["file"],
        input["target_location"]["rank"].to_i
      ]
      
      enemy_pawn = Position.new( target_file, en_passant_enemy_pawn_rank( 
        target_rank, 
        players_info.enemy_team )
      )
      target_position = Position.new( target_file, target_rank )
      return piece_position, enemy_pawn, target_position
    end
    
    def en_passant_enemy_pawn_rank( unadjusted_rank, team )
      team == :white ? unadjusted_rank + WHITE_EN_PASSANT_RANK : unadjusted_rank + BLACK_EN_PASSANT_RANK
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