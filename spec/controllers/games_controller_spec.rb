require "rails_helper"

describe GamesController do
  let( :game ) { stub_model Game }
  let( :json_board ) { JSON.generate( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :new_game ) { double( "new_game" ) }
  
  before :each do
    allow( Game ).to receive( :find ).and_return game
    
    allow( game ).to receive( :board ).and_return( json_board )
    
    stub_const( "BoardJsonParser", Class.new )
    allow( BoardJsonParser ).to receive( :translate_json_board )
    
    stub_const( "PlayGame", Class.new )
    allow( PlayGame ).to receive( :new ).and_return new_game
    allow( new_game ).to receive( :call )
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
    let( :params ) { { "piece_location"=>"a4", "target_location"=>"d6", "en_passant"=>"1", "game_id" => "#{game.id}" } }
    
    it "redirects to the game_home page" do
      post :input, params
      
      expect( response ).to redirect_to game_home_path( game.id )
    end
    
    context "when player selects en_passant" do
      it "instantiates a new PlayGame object" do
        post :input, params
      
        expect( PlayGame ).to have_received( :new ).
          with( params.merge( "controller"=>"games", "action"=>"input" ), controller )
      end
    end
    
    context "when player does NOT select en_passant" do
      it "instantiates a new PlayGame object" do
        params_without_en_passant = { "piece_location"=>"a4", "target_location"=>"d6", "en_passant"=>"1", "game_id" => "#{game.id}" }
        post :input, params_without_en_passant
      
        expect( PlayGame ).to have_received( :new ).
          with( params_without_en_passant.merge( "controller"=>"games", "action"=>"input" ), controller )
      end
    end
    
    it do
      post :input, params
      
      expect( new_game ).to have_received( :call )
    end
  end
end