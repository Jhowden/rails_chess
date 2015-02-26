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
  let( :status_map ) do
    {
      current_player:
      {id: 5, team: :white}, 
      enemy_player:
      {id: 2, team: :black}
      }
  end
  let( :json_board ) { JSON.generate chess_board }
  let( :players_info ) { described_class.new( status_map, json_board ) }
  
  it "finds the current player and enemy player's team color" do
    expect( players_info.current_team ).to eq :white
    expect( players_info.enemy_team ).to eq :black
  end
end