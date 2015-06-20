require "find_pieces/find_team_pieces"
require "game_start/players_information"
require "game_start/checkmate"
require "game_start/check"
require "move_sequence/standard_sequence"
require "board_jsonifier"

class StartMoveSequence
  attr_reader :observer, :game, :input, :players_info
  INVALID_MOVE_MSG = "Invalid move. Please select another move."
  
  def initialize( observer, input, game_id )
    @observer = observer
    @input = input
    @game = Game.find game_id
    @players_info = GameStart::PlayersInformation.new(
      game.determine_players_status, game.board )
  end
  
  def start()
    if king_in_check?
      possible_escape_moves = checkmate.find_checkmate_escape_moves

      move_seq = case input
        when ParsedInput::Standard
          MoveSequence::StandardSequence.new( 
            possible_escape_moves, input, players_info )
        when ParsedInput::EnPassant
          MoveSequence::EnPassantSequence.new(
            possible_escape_moves, input, players_info )
        else
          MoveSequence::NullSequence.new
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
          observer.on_successful_move( response_message )  
        end
        game.user_inputs.create!( input.chess_notation )
      else
        observer.on_failed_move( INVALID_MOVE_MSG )
      end
    else
      move_seq = case input
        when ParsedInput::Standard
          MoveSequence::StandardSequence.new( 
            find_pieces_moves, input, players_info )
        when ParsedInput::EnPassant
          MoveSequence::EnPassantSequence.new(
            find_pieces_moves, input, players_info )
        when ParsedInput::Castle
          MoveSequence::CastleSequence.new( input, players_info )
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
          observer.on_successful_move( response_message )
        end
        game.user_inputs.create!( input.chess_notation )
      end
    end
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
  
  # this should be someplace else
  def king_in_check?()
    GameStart::Check.king_in_check?( 
      FindPieces::FindTeamPieces.
        find_king_piece( 
          players_info.current_team, 
          board ),
      FindPieces::FindTeamPieces.
        find_pieces( 
        players_info.enemy_team, 
        board )
    )
  end
  
  def find_pieces_moves()
    FindPieces::FindTeamPieces.
      find_pieces( 
      players_info.current_team, 
      board ).map( &:determine_possible_moves ).flatten( 1 ).
        uniq.map{ |move| move.map( &:to_s ).join }
  end
  
  def board()
    BoardJsonParser.parse_json_board( players_info.json_board )
  end
end