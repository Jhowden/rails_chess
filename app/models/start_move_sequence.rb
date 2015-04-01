require "find_pieces/find_team_pieces"
require "game_start/players_information"
require "game_start/checkmate"
require "game_start/check"
require "move_sequence/standard_king_in_check_sequence"
require "board_jsonifier"

class StartMoveSequence
  attr_reader :observer, :game, :input, :players_info
  INVALID_MOVE_MSG = "Invalid move. Please select another move."
  
  def initialize( observer, input, game_id )
    @observer = observer
    @input = input
    @game = Game.find game_id
    @players_info = GameStart::PlayersInformation.new(
      game.determine_players_status, game.board
    )
  end
  
  def start()
    if king_in_check? players_info
      possible_escape_moves = checkmate.find_checkmate_escape_moves


      case input
      when ParsedInput::Standard
        move_seq = MoveSequence::StandardKingInCheckSequence.new( 
          possible_escape_moves, input, players_info )
      when ParsedInput::EnPassant
        move_seq = MoveSequence::EnPassantCheckSequence.new(
          possible_escape_moves, input, players_info )
      end
      
      if move_seq.valid_move?
        board, response_message = move_seq.response
        json_board = BoardJsonifier.jsonify_board( board.chess_board )
        
        if checkmate.match_finished?
          game.update_attributes( board: json_board, 
            winner: players_info.current_team )
        else
          game.update_attributes( board: json_board, 
            player_turn: players_info.enemy_team_id )
        end
        observer.on_successful_move( response_message )
      else
        observer.on_failed_move( INVALID_MOVE_MSG )
      end
    end
    
    # increase move counter for piece -> do this inside checksequence object
    # update en_passant status of pawns -> do this inside checksequence object
    # check to see if other player's king is in check, display flash message
    # create new AR model ( Game Moves ) and update record to reflect move
    # check to see if there is checkmate after move
  end
  
  private
  
  def checkmate()
    return @checkmate if @checkmate
    @checkmate = GameStart::Checkmate.new( 
        players_info.json_board,
        players_info.current_team,
        players_info.enemy_team 
      )
  end
  
  def king_in_check?( players_info )
    GameStart::Check.king_in_check?( 
      FindPieces::FindTeamPieces.
        find_king_piece( 
          players_info.current_team, 
          BoardJsonParser.parse_json_board( players_info.json_board ) ),
      FindPieces::FindTeamPieces.
        find_pieces( 
        players_info.enemy_team, 
        BoardJsonParser.parse_json_board( players_info.json_board ) )
    )
  end
end