require "rails_helper"

describe GameStart::Checkmate do
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
                           "capture_through_en_passant" => true } )}
    
  let( :enemy_rook )   { GamePieces::Rook.new( { 
                           "file" => "a", 
                           "rank" => 4, 
                           "team" => :white, 
                           "board" => nil } )}
    
  let( :json_board ) do
    [[nil, {"klass"=>"GamePieces::King", "attributes"=>{"file"=>"b", "rank"=>8, "team"=>:black, "captured"=>nil, "move_counter"=>0, "checkmate"=>false}}, {"klass"=>"GamePieces::Knight", "attributes"=>{"file"=>"c", "rank"=>8, "team"=>:black, "captured"=>nil, "move_counter"=>0}}, nil, nil, nil, nil, nil], 
    [{"klass"=>"GamePieces::Bishop", "attributes"=>{"file"=>"a", "rank"=>7, "team"=>:white, "captured"=>nil, "move_counter"=>0}}, nil, {"klass"=>"GamePieces::Pawn", "attributes"=>{"file"=>"c", "rank"=>7, "team"=>:white, "captured"=>nil, "move_counter"=>0, "orientation"=>:up, "capture_through_en_passant"=>true}}, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass"=>"GamePieces::Rook", "attributes"=>{"file"=>"a", "rank"=>4, "team"=>:white, "captured"=>nil, "move_counter"=>0}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil]]
  end
  
  describe "#find_checkmate_escape_moves" do
    before :each do
      board.chess_board[0][1] = king
      board.chess_board[0][2] = knight
      board.chess_board[1][0] = enemy_bishop
      board.chess_board[1][2] = enemy_pawn
      board.chess_board[4][0] = enemy_rook
      
      [king, knight, enemy_bishop, enemy_pawn, enemy_rook].each do |piece|
        piece.board = board
      end
      
      @checkmate = described_class.new( JSON.generate( json_board ),
        king, [knight, king], [enemy_bishop, enemy_pawn, enemy_rook] )
    end
    
    it "returns a list of possible moves" do
      expect( @checkmate.find_checkmate_escape_moves ).to eq( 
        [["b", 8, "a", 8], ["b", 8, "c", 7], ["b", 8, "b", 7]]
      )
    end
    
    it "returns the board to its original state" do
      @checkmate.find_checkmate_escape_moves
      
      expect( enemy_bishop.board.chess_board[0][1].class ).to eq king.class
      expect( enemy_bishop.board.chess_board[0][2].class ).to eq knight.class
      expect( enemy_bishop.board.chess_board[1][0].class ).to eq enemy_bishop.class
      expect( enemy_bishop.board.chess_board[1][2].class ).to eq enemy_pawn.class
      expect( enemy_bishop.board.chess_board[4][0].class ).to eq enemy_rook.class
    end
  end
end