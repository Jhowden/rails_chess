class GamesController < ApplicationController
  before_filter :find_game
  
  def home
    @board = BoardJsonParser.translate_json_board @game.board
  end
  
  private
  
  def find_game
    @game = Game.find params[:game_id]
  end
end