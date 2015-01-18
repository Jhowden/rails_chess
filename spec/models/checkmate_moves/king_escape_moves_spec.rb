require "rails_helper"

describe CheckmateMoves::KingEscapeMoves do
  let( :board )        { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :king )         { GamePieces::King.new( { 
                           "file" => "b", 
                           "rank" => 8, 
                           "team" => :black, 
                           "board" => nil, 
                           "checkmate" => false } ) }
    
  let( :knight )       { GamePieces::Knight.new( { 
                           "file" => "c", 
                           "rank" => 8, 
                           "team" => :black, 
                           "board" => nil } ) }
      
  let( :enemy_bishop ) { GamePieces::Bishop.new( { 
                           "file" => "a", 
                           "rank" => 7, 
                           "team" => :white, 
                           "board" => nil } ) }
    
  let( :enemy_pawn )   { GamePieces::Pawn.new( { 
                           "file" => "c", 
                           "rank" => 7, 
                           "team" => "white", 
                           "board" => nil, 
                           "orientation" => "up", 
                           "capture_through_en_passant" => true } ) }
    
  let( :enemy_rook )   { GamePieces::Rook.new( { 
                           "file" => "a", 
                           "rank" => 4, 
                           "team" => :white, 
                           "board" => nil } ) }
    
  let( :json_board ) do
    [[nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, {"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil], 
    [{"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"a", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, {"klass"=>"GamePieces::Pawn", "attributes"=>{"file"=>"c", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0, "orientation"=>:up, "capture_through_en_passant"=>true}}, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>4, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
    
  before :each do
    board.chess_board[0][1] = king
    board.chess_board[0][2] = knight
    board.chess_board[1][0] = enemy_bishop
    board.chess_board[1][2] = enemy_pawn
    board.chess_board[4][0] = enemy_rook
    
    [king, knight, enemy_bishop, enemy_pawn, enemy_rook].each do |piece|
      piece.board = board
    end
  end
    
  describe ".find_moves" do
    it "finds all of the kings possible moves" do
      expect( described_class.
        find_moves( JSON.generate( json_board ), :black, :white ) ).to eq( 
          [
            ["b", 8, "a", 8],
            ["b", 8, "c", 7],
            ["b", 8, "b", 7],
          ]
        )
    end
    
    context "when there are no possible moves" do
      let( :rook )        { GamePieces::Rook.new( { 
                               "file" => "a", 
                               "rank" => 7, 
                               "team" => :black, 
                               "board" => nil } ) }

      let( :king )         { GamePieces::King.new( { 
                               "file" => "a", 
                               "rank" => 8, 
                               "team" => :black, 
                               "board" => nil, 
                               "checkmate" => false } ) }

      let( :knight )       { GamePieces::Knight.new( { 
                              "file" => "b", 
                              "rank" => 8, 
                              "team" => :black, 
                              "board" => nil } ) }

      let( :enemy_bishop ) { GamePieces::Bishop.new( { 
                              "file" => "c", 
                              "rank" => 6, 
                              "team" => :white, 
                              "board" => nil } ) }
                               
      let( :json_board ) do
        [[{"klass"=>"GamePieces::King", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, {"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil], 
        [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>7, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, {"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"c", "rank"=>6, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil], 
        [nil, nil, nil, nil, nil, nil, nil, nil]]
      end
      
      before :each do
        board.chess_board[0][0] = king
        board.chess_board[0][1] = knight
        board.chess_board[2][2] = enemy_bishop
        board.chess_board[1][0] = rook
    
        [king, knight, enemy_bishop, enemy_rook].each do |piece|
          piece.board = board
        end
      end
      
      it "returns an empty array" do
        expect( described_class.
          find_moves( JSON.generate( json_board ), :black, :white ) ).to eq(
            []
          )
      end
    end
  end
end