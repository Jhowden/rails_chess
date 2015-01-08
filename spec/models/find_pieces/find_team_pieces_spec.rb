require "rails_helper"
require "board_json_parser"

describe FindPieces::FindTeamPieces do
  let( :chess_board ) do
    [[{"klass" => "GamePieces::Rook", "attributes" => {"file" => "a", "rank" => 8, "team" => "white", "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass" => "GamePieces::King", "attributes" => {"file" => "a", "rank" => 7, "team" => "white", "captured" => false, "move_counter" => 1, "checkmate" => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "b" , "rank" => 2, "team" => "black", "captured" => false, "move_counter" => 0, "orientation" => "up",  "capture_through_en_passant" => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Bishop", "attributes" => {"file" => "b", "rank" => 1, "team" => "black", "captured" => true, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  let( :board ) { Board.new( 
    BoardJsonParser.parse_json_board( JSON.generate chess_board ) ) }
  
  describe ".find_pieces" do
    it "only returns the pieces that have NOT been captured" do
      expect( described_class.
        find_pieces( :black, board ).size ).to eq 1
    end
    
    it "finds a teams pieces by color" do
      piece = described_class.find_pieces( :black, board ).first
      expect( piece ).to be_instance_of GamePieces::Pawn
      expect( piece.orientation ).to eq :up
      expect( piece.capture_through_en_passant ).to eq true
      expect( piece.position.rank ).to eq 2
      expect( piece.position.file ).to eq "b"
      expect( piece.captured ).to eq false
      expect( piece.move_counter ).to eq 0
      expect( piece.team ).to eq :black
      expect( piece.board ).to be_instance_of Board
      expect( piece.board.chess_board[0][0] ).to be_instance_of GamePieces::Rook
    end
    
    it "finds a teams pieces by color" do
      piece = described_class.find_pieces( :white, board ).first
      expect( piece ).to be_instance_of GamePieces::Rook
      expect( piece.position.rank ).to eq 8
      expect( piece.position.file ).to eq "a"
      expect( piece.captured ).to eq false
      expect( piece.move_counter ).to eq 0
      expect( piece.team ).to eq :white
      expect( piece.board ).to be_instance_of Board
      expect( piece.board.chess_board[0][0] ).to be_instance_of GamePieces::Rook
    end
  end
  
  describe ".find_king_piece" do
    it "finds the king piece" do
      king = described_class.find_king_piece( :white, board )
      expect( king ).to be_instance_of GamePieces::King
      expect( king.position.file ).to eq "a"
      expect( king.position.rank ).to eq 7
      expect( king.team ).to eq :white
      expect( king.captured ).to eq false
      expect( king.move_counter ).to eq 1
      expect( king.board ).to be_instance_of Board
      expect( king.board.chess_board[0][0] ).to be_instance_of GamePieces::Rook
    end
  end
end