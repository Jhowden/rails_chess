class GamesController < ApplicationController
  before_filter :find_game
  
  def home
    @board = BoardJsonParser.parse_json_board @game.board
  end
  
  def input
    PlayGame.new( params, self ).call
    redirect_to game_home_path( @game )
  end
  
  def on_failed_move( message )
    flash[:error] = message
  end
  
  private
  
  def find_game
    @game = Game.find params[:game_id]
  end
end