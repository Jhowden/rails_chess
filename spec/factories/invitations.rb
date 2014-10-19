FactoryGirl.define do
  factory :invitation do
    sender_id 6
    receiver_id 5
    game_link "game/6/play"
    game_id 2
  end
end