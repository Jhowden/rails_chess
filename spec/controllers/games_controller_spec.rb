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
  
  describe "GET #index" do
    it "finds the Game" do
      get :home, game_id: 2
      
      expect( Game ).to have_received( :find ).with "2"
    end
    
    it "parses the JSON board" do
      get :home, game_id: 2
      
      expect( BoardJsonParser ).to have_received( :translate_json_board ).
        with json_board
    end
  end
end