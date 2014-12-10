class PlayGame
  attr_reader :params, :observer

  def initialize( params, observer )
    @params = params
    @game_id = params.fetch( "game_id" )
    @observer = observer
  end
  
  def call
    valid_input = UserCommand.new( params ).valid_input?
    if valid_input
      # check to see if the game is over
      # perform StartMoveSequence
        # what do I need to pass in? GameBoard, Players, user_command, ???
        # how do I figure out the pieces for each team?
    else
      observer.on_failed_move
    end
  end
end