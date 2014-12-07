class GamesController < ApplicationController
  before_filter :find_game
  
  def home
    @board = BoardJsonParser.translate_json_board @game.board
  end
  
  def input
    # if input is good, update the board and store it
    # if input is bad, render same template and ask for new input
    
    # put into UserCommands object to correctly parse input string ( with e.p. at end ) and pass into Game object that does logic stuff
    
    # have a PlayGame class that is a wrapper around everything. I takes in the user_input and then goes off.. 
    # this would have PlayGame have a lot of knowledge of other objects...
    PlayGame.new( params, self ).call
    redirect_to game_home_path( @game )
  end
  
  def on_invalid_input
    flash[:error] = "Input was invalid. Please try again."
  end
  
  private
  
  def find_game
    @game = Game.find params[:game_id]
  end
end