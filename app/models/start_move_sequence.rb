require "find_pieces/find_team_pieces"
require "game_start/players_information"
require "game_start/checkmate"
require "game_start/check"
require "move_sequence/standard_king_in_check_sequence"
require "board_jsonifier"

class StartMoveSequence
  attr_reader :observer, :game, :input
  def initialize( observer, input, game_id )
    @observer = observer
    @input = input
    @game = Game.find game_id
  end
  
  def start
    players_info = GameStart::PlayersInformation.new( 
    # this should be an intance method
      Game.determine_players_status( 
        game.white_team_id, 
        game.black_team_id, 
        game.player_turn
      ), game.board
    )
    
    # the input argument should containt what type of sequence it needs to perform
    
    if king_in_check? players_info
      possible_escape_moves = GameStart::Checkmate.new( 
        players_info.json_board,
        players_info.current_team,
        players_info.enemy_team 
      ).find_checkmate_escape_moves


      case input
      when ParsedInput::Standard
        move_seq = MoveSequence::StandardKingInCheckSequence.new( 
          possible_escape_moves, input, players_info, observer, game )
        if move_seq.valid_move?
          board, response_message = move_seq.response
          game.update_attributes( board: BoardJsonifier.jsonify_board( board.chess_board ), 
            player_turn: players_info.enemy_team )
          observer.on_successful_move( response_message )
        end
      end
    end
    
    # increase move counter for piece
    # update en_passant status of pawns
    # check to see if other player's king is in check, display flash message
    # check to see if there is checkmate after move
  end
  
  private
  
  def king_in_check? players_info
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