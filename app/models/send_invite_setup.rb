class SendInviteSetup
  
  attr_reader :observer, :params, :player
  
  def initialize( observer, params, player )
    @observer = observer
    @params = params
    @player = player
  end
  
  def call
    game = create_game
    
    save_the_game( game )
  end
  
  private
  
  def save_the_game( game )
    if game.save!
      invitation = create_invitation( game.id )
      
      save_the_invitation( invitation )  
    else
      observer.send( :invitation_failed_to_be_created )
    end
  end
  
  def save_the_invitation( invitation )
    if invitation.save!
      observer.send( :invitation_successfully_created,
        invitation )
    else
      observer.send( :invitation_failed_to_be_created )
    end
  end
  
  def create_game( board_dimension = Array.new( 8 ) { |cell| Array.new( 8 ) } )
    board = Board.new( board_dimension )
    board.place_pieces_on_board
    json_board = BoardJsonifier.jsonify_board board.chess_board
    Game.new( 
      white_team_id: player.id, 
      black_team_id: params["receiver_id"].to_i,
      player_turn: player.id,
      board: json_board )
  end
  
  def create_invitation( game_id )
    Invitation.new(
      sender_id: player.id,
      receiver_id: params["receiver_id"].to_i,
      game_id: game_id,
      game_link: Invitation.create_game_link( game_id ) )
  end
end