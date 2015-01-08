require "find_pieces/find_team_pieces"
require "game_start/players_information"
require "game_start/checkmate"
require "game_start/check"

class StartMoveSequence
  
  def initialize( observer, input_type, game_id )
    @observer = observer
    @input = input_type.input
    @game = Game.find game_id
  end
  
  def start
    players_information = GameStart::PlayersInformation.new( 
      Game.determine_players_status( 
        @game.white_team_id, 
        @game.black_team_id, 
        @game.player_turn
      ), @game.board
    )
    
    if king_in_check? players_information
      posible_escape_moves = GameStart::Checkmate.new( 
        players_information.json_board,
        players_information.current_player_team,
        players_information.enemy_player_team 
      ).find_checkmate_escape_moves

      # pass possible escape moves list, player, and enemy player into MoveSequence
    end
    # put the board on each piece (maybe I don't have to put it on each piece, just the piece that I select)
    # check to see if player is in check
      # find the list possible moves to get out of check
    # check to see if piece selected is same team as current player
    # parse the input properly
    # check to see that the move can happen (doesn't put current player's king in check)
    # increase move counter for piece
    # update en_passant status of pawns
    # check to see if other player's king is in check, display flash message
    # check to see if there is checkmate after move
  end
  
  private
  
  def king_in_check? players_information
    GameStart::Check.king_in_check?( 
      FindPieces::FindTeamPieces.
        find_king_piece( 
          players_information.current_player_team, 
          players_information.json_board ),
      FindPieces::FindTeamPieces.
        find_pieces( 
        players_information.enemy_player_team, 
        players_information.json_board ) 
    )
  end
end