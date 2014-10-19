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
      invitation.create_game_link
      
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
  
  def create_game( board = Board.new )
    board.create_board
    Game.new( 
      white_team_id: player.id, 
      black_team_id: params["receiver_id"].to_i,
      player_turn: player.id,
      board: board )
  end
  
  def create_invitation( game_id )
    Invitation.new(
      sender_id: player.id,
      receiver_id: params["receiver_id"].to_i,
      game_id: game_id )
  end
end