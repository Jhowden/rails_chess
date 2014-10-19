FactoryGirl.define do
  factory :game do
    board [" ", " ", " "].to_json
    white_team_id 6
    black_team_id 5
    player_turn 6
  end
end