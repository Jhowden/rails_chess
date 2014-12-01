require "rails_helper"

describe GamesController do
  let( :game ) { stub_model Game }
  let( :json_board ) { JSON.generate( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  
  before :each do
    allow( Game ).to receive( :find ).and_return game
    
    allow( game ).to receive( :board ).and_return( json_board )
    
    stub_const( "BoardJsonParser", Class.new )
    allow( BoardJsonParser ).to receive( :translate_json_board )
  end
  
  describe "GET #home" do
    it "finds the Game" do
      get :home, game_id: 2
      
      expect( Game ).to have_received( :find ).with "2"
    end
    
    it "parses the JSON board" do
      get :home, game_id: 2
      
      expect( BoardJsonParser ).to have_received( :translate_json_board ).
        with json_board
    end
    
    it "renders the home template" do
      get :home, game_id: 2
      
      expect( response ).to render_template :home
    end
  end
  
  describe "POST #input" do
    it "redirects to the game_home page" do
      post :input, { "user_input" => "a3 b4", "en_passant" => "1", "game_id" => "#{game.id}" }
      
      expect( response ).to redirect_to game_home_path( game.id )
    end
  end
end