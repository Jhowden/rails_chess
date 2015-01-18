require "rails_helper"

describe CheckmateMoves::BlockPieceMoves do
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
                           "file" => "a", 
                           "rank" => 7, 
                           "team" => :black, 
                           "board" => nil } ) }
    
  let( :enemy_bishop )   { GamePieces::Bishop.new( { 
                           "file" => "f", 
                           "rank" => 4, 
                           "team" => :white, 
                           "board" => nil } ) }
    
  let( :enemy_rook )   { GamePieces::Rook.new( { 
                           "file" => "b", 
                           "rank" => 5, 
                           "team" => :white, 
                           "board" => nil } ) }
                           
  let( :json_board ) do
    [[{"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil, nil], 
    [{"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"a", "rank"=>7, "team"=>:black, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"b", "rank"=>5, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  describe ".find_moves" do
    before :each do
      board.chess_board[0][1] = king
      board.chess_board[0][0] = knight
      board.chess_board[1][0] = bishop
      board.chess_board[3][1] = enemy_rook
    
      [king, knight, bishop, enemy_rook].each do |piece|
        piece.board = board
      end
    end
    
    it "finds all moves that capture threatening pieces" do
      expect( described_class.
        find_moves( JSON.generate( json_board ), :black, :white ) ).to eq( 
          [
            ["a", 8, "b", 6],
            ["a", 7, "b", 6]
          ]
        )
    end
    
    context "when there are two threatening pieces" do
      let( :json_board ) do
        [[{"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"a", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0}}, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>false, "move_counter"=>0, "checkmate"=>false}}, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, {"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"b", "rank"=>5, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, {"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"f", "rank"=>4, "team"=>:white, "captured"=>false, "move_counter"=>0}}, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]]
      end

      before :each do
        board.chess_board[0][1] = king
        board.chess_board[0][0] = knight
        board.chess_board[1][0] = bishop
        board.chess_board[3][1] = enemy_rook
        board.chess_board[4][5] = enemy_bishop

        [king, knight, bishop, enemy_rook, enemy_bishop].each do |piece|
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