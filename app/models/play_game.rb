class PlayGame
  attr_reader :params, :observer, :game_id
  
  INVALID_INPUT = "Input was invalid. Please try again."

  def initialize( params, observer )
    @params = params
    @game_id = params.fetch( "game_id" )
    @observer = observer
  end
  
  def call
    command = UserCommand.new( params )
    if command.valid_input?
      StartMoveSequence.new( observer, command.get_input, game_id ).start
    else
      observer.on_failed_move INVALID_INPUT
    end
  end
end