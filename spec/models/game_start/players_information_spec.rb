require "rails_helper"

describe GameStart::PlayersInformation do
  let( :chess_board ) do
    [[{"klass" => "GamePieces::Rook", "attributes" => {"file" => "a", "rank" => 8, "team" => "white", "captured" => false, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil, nil], 
    [{"klass" => "GamePieces::King", "attributes" => {"file" => "a", "rank" => 7, "team" => "white", "captured" => false, "move_counter" => 0, "checkmate" => false}}, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, nil, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Pawn", "attributes" => {"file" => "b" , "rank" => 2, "team" => "black", "captured" => false, "move_counter" => 0, "orientation" => "up",  "capture_through_en_passant" => true}}, nil, nil, nil, nil, nil, nil], 
    [nil, {"klass" => "GamePieces::Bishop", "attributes" => {"file" => "b", "rank" => 1, "team" => "black", "captured" => true, "move_counter" => 0}}, nil, nil, nil, nil, nil, nil]]
  end
  let( :new_chess_board ) { double( "new_chess_board" ) }
  let( :status_map ) do
    {
      current_player:
      {id: 5, team: :white}, 
      enemy_player:
      {id: 2, team: :black}
      }
  end
  let( :json_board ) { JSON.generate chess_board }
  let( :players ) { described_class.new( status_map, json_board) }
  
  it "finds a player's pieces" do
    piece = players.enemy_player_pieces.first
    expect( piece ).to be_instance_of GamePieces::Pawn
    expect( piece.orientation ).to eq :up
    expect( piece.capture_through_en_passant ).to eq true
    expect( piece.position.rank ).to eq 2
    expect( piece.position.file ).to eq "b"
    expect( piece.captured ).to eq false
    expect( piece.move_counter ).to eq 0
    expect( piece.team ).to eq :black
    expect( piece.board ).to be_instance_of Board
  end
  
  it "does not find a player's piece that has been captured" do
    expect( players.enemy_player_pieces.any? { |piece| piece.class == GamePieces::Bishop } ).to be_falsey
  end
  
  it "find a player's king" do
    king = players.current_player_king
    expect( king ).to be_instance_of GamePieces::King
    expect( king.position.file ).to eq "a"
    expect( king.position.rank ).to eq 7
    expect( king.team ).to eq :white  
    expect( king.captured ).to eq false  
    expect( king.move_counter ).to eq 0  
    expect( king.board ).to be_instance_of Board
  end
end