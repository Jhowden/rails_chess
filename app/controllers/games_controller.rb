class GamesController < ApplicationController
  before_filter :find_game
  
  def home
    @board = BoardJsonParser.translate_json_board @game.board
  end
  
  def input
    # if input is good, update the board and store it
    # if input is bad, render same template and ask for new input
    
    # put into UserCommands object to correctly parse input string ( with e.p. at end ) and pass into Game object that does logic stuff
    redirect_to game_home_path( @game )
  end
  
  private
  
  def find_game
    @game = Game.find params[:game_id]
  end
end