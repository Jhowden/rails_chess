require "board_json_parser"
require "board_jsonifier"
# require "find_pieces/find_team_pieces"

module MoveSequence
  class StandardKingInCheckSequence
    attr_reader :escape_moves, :input, :current_team, :enemy_team, :observer, :json_board, :game
    
    def initialize escape_moves, input_type, players_info, observer, game
      @escape_moves = escape_moves
      @input = input_type.input
      @current_team = players_info.current_team
      @enemy_team = players_info.enemy_team
      @json_board = players_info.json_board
      @observer = observer
      @game = game
    end
    
    def valid_move?
      return false unless escape_moves.include? transformed_input
      board = Board.new( BoardJsonParser.parse_json_board( json_board ) )
      piece_position, target_position = find_positions
      piece = board.find_piece_on_board piece_position
      # need to do checks to see if piece belongs to team and piece can perform that move
      if piece.team == current_team
        piece.update_piece_position target_position
        board.update_board piece
        board.remove_old_position piece_position
        king_in_check?( board )
      end
    end
    
    private
    
    def transformed_input
      piece = input["piece_location"]["file"] + input["piece_location"]["rank"]
      target = input["target_location"]["file"] + input["target_location"]["rank"]
      
      piece + target
    end
    
    def find_positions
      piece_location = Position.new(
        input["piece_location"]["file"],
        input["piece_location"]["rank"].to_i 
      )
      enemy_location = Position.new(
        input["target_location"]["file"],
        input["target_location"]["rank"].to_i
      )

      return piece_location, enemy_location
    end
    
    def king_in_check? updated_board
      GameStart::Check.king_in_check?( 
        FindPieces::FindTeamPieces.
          find_king_piece( 
            current_team, 
            updated_board ),
        FindPieces::FindTeamPieces.
          find_pieces( 
          enemy_team, 
          updated_board ) 
      )
    end
  end
end