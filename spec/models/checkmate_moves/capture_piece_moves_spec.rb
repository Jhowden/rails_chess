require "rails_helper"

describe CheckmateMoves::CapturePieceMoves do
  let( :board )        { Board.new( Array.new( 8 ) { |cell| Array.new( 8 ) } ) }
  let( :king )         { GamePieces::King.new( { 
                           "file" => "b", 
                           "rank" => 8, 
                           "team" => :black, 
                           "board" => nil, 
                           "checkmate" => false } ) }
    
  let( :knight )       { GamePieces::Knight.new( { 
                           "file" => "a", 
                           "rank" => 8, 
                           "team" => :black, 
                           "board" => nil } ) }
      
  let( :bishop )       { GamePieces::Bishop.new( { 
                           "file" => "e", 
                           "rank" => 5, 
                           "team" => :black, 
                           "board" => nil } ) }
    
  let( :enemy_pawn )   { GamePieces::Pawn.new( { 
                           "file" => "c", 
                           "rank" => 7, 
                           "team" => :white, 
                           "board" => nil, 
                           "orientation" => "up", 
                           "capture_through_en_passant" => true } ) }
    
  let( :enemy_rook )   { GamePieces::Rook.new( { 
                           "file" => "b", 
                           "rank" => 5, 
                           "team" => :white, 
                           "board" => nil } ) }
                           
  let( :json_board ) do
    [[{"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil, nil], 
    [nil, nil, {"klass"=>"GamePieces::Pawn", "attributes"=>{"file"=>"c", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0, "orientation"=>:up, "capture_through_en_passant"=>true}}, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, {"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"e", "rank"=>5, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".find_moves" do
    before :each do
      board.chess_board[0][1] = king
      board.chess_board[0][0] = knight
      board.chess_board[3][4] = bishop
      board.chess_board[1][2] = enemy_pawn
    
      [king, knight, bishop, enemy_pawn].each do |piece|
        piece.board = board
      end
    end
    
    it "finds all moves that capture threatening pieces" do
      expect( described_class.
        find_moves( JSON.generate( json_board ), :black, :white ) ).to eq( 
          [
            ["a", 8, "c", 7],
            ["e", 5, "c", 7]
          ]
        )
    end
    
    context "when there are two threatening pieces" do
      let( :json_board ) do
        [[{"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil, nil],
        [nil, nil, {"klass"=>"GamePieces::Pawn", "attributes"=>{"file"=>"c", "rank"=>7, "team"=>:white, "captured"=>false, "move_counter"=>0, "orientation"=>:up, "capture_through_en_passant"=>true}}, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"b", "rank"=>5, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, {"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"e", "rank"=>5, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]]
      end
      
      before :each do
        board.chess_board[0][1] = king
        board.chess_board[0][0] = knight
        board.chess_board[3][4] = bishop
        board.chess_board[1][2] = enemy_pawn
        board.chess_board[3][1] = enemy_rook
    
        [king, knight, bishop, enemy_pawn, enemy_rook].each do |piece|
          piece.board = board
        end
      end
      
      it "returns an empty array" do
        expect( described_class.
          find_moves( JSON.generate( json_board ), :black, :white ) ).to eq []
      end
    end
  end
end