require "rails_helper"

describe BoardJsonParser do
  let( :transformed_board ) do
    [[{"klass" => "GamePieces::Rook", "attributes" => {"file" => "a", "rank" => 8, "team" => "white", "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass" => "GamePieces::King", "attributes" => {"file" => "a", "rank" => 7, "team" => "white", "captured" => false, "move_counter" => 0, "checkmate" => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "b" , "rank" => 2, "team" => "black", "captured" => false, "move_counter" => 0, "orientation" => "up",  "capture_through_en_passant" => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Bishop", "attributes" => {"file" => "b", "rank" => 1, "team" => "black", "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".translate_json_board" do
    before :each do
      allow( JSON ).to receive( :parse ).and_return transformed_board
      
      allow( GamePieces::Rook ).to receive( :new )
      allow( GamePieces::Pawn ).to receive( :new )
      allow( GamePieces::King ).to receive( :new )
      allow( GamePieces::Bishop ).to receive( :new )
      
      @json_board = JSON.generate( transformed_board )
    end
    
    it "parses the JSON board" do
      described_class.translate_json_board( @json_board )
      
      expect( JSON ).to have_received( :parse ).with( @json_board )
    end
    
    it "places a new instance of a Rook" do
      recreated_board = described_class.translate_json_board( @json_board )
      expect(  GamePieces::Rook ).to have_received( :new ).with(
        { 
          "file" => "a", 
          "rank" => 8, 
          "team" => "white", 
          "captured" => false, 
          "move_counter" => 0 
        }
      )
    end
    
    it "places a new instance of a King" do
      recreated_board = described_class.translate_json_board( @json_board )
      expect(  GamePieces::King ).to have_received( :new ).with(
        { 
          "file" => "a", 
          "rank" => 7, 
          "team" => "white", 
          "captured" => false, 
          "move_counter" => 0,
         "checkmate" => false
        }
      )
    end
        
    it "places a new instance of a Pawn" do
      recreated_board = described_class.translate_json_board( @json_board )
      expect(  GamePieces::Pawn ).to have_received( :new ).with(
        { 
          "file" => "b" , 
          "rank" => 2, 
          "team" => "black", 
          "captured" => false, 
          "move_counter" => 0, 
          "orientation" => "up",  
          "capture_through_en_passant" => true
        }
      )
    end
    
    it "places a new instance of a Bishop" do
      recreated_board = described_class.translate_json_board( @json_board )
      expect(  GamePieces::Bishop ).to have_received( :new ).with(
        {
          "file" => "b", 
          "rank" => 1, 
          "team" => "black", 
          "captured" => false, 
         "move_counter" => 0
       }
      )
    end
  end
end