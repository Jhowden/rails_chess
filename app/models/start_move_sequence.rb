class StartMoveSequence
  
  def initialize( observer, input_type, game_id )
    @observer = observer
    @input = input_type.input
    @game = Game.find game_id
  end
  
  def call
    # need to check for checkmate in the view to not display input form
    # display winner in the view
    # 
  end
end