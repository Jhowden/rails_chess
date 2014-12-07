class UserCommand
  VALID_USER_MOVE_INPUT = /^[a-h]{1}[1-8]{1}$/
  
  attr_reader :piece_location, :target_location, :en_passant, :castle_input
  
  def initialize input_map
    @piece_location    = input_map.fetch( "piece_location" )
    @target_location   = input_map.fetch( "target_location" )
    @en_passant        = input_map.fetch( "en_passant", nil )
    @castle_input      = input_map.fetch( "castle", nil)
  end
  
  def valid_input?
    return false if invalid_input
    
    castle_input ||
      [piece_location, target_location].
        all? { |input| input =~ VALID_USER_MOVE_INPUT }
  end
  
  def parsed_input
    if en_passant
      starting_input_map.merge( "en_passant" => en_passant )
    elsif castle_input
      {"castle" => castle_input}
    else
      starting_input_map
    end
  end
  
  private
  
  def starting_input_map
    {
      "piece_location" => 
        { 
          "file" => piece_location.first, 
          "rank" => piece_location.last
        },
      "target_location" => 
        {
          "file" => target_location.first, 
          "rank" => target_location.last
        }
    }
  end
  
  def castle_and_location_input?
    castle_input && target_location != "" || castle_input && piece_location != ""
  end
  
  def castle_and_en_passant_input?
    castle_input && en_passant
  end
  
  def invalid_input
    castle_and_location_input? || castle_and_en_passant_input?
  end
end