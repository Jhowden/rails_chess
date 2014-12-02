class PlayGame
  attr_reader :params

  def initialize( params, observer )
    @params = params
    @game_id = params.fetch( "game_id" )
    @observer = observer
  end
  
  def call
    valid_input = UserCommand.new( params ).valid_input?
  end
end