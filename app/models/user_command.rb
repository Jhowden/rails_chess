class UserCommand
  VALID_USER_MOVE_INPUT = /^[a-h]{1}[1-8]{1}$/
  
  attr_reader :piece_location, :target_location, :en_passant
  
  def initialize input_map
    @piece_location  = input_map.fetch( "piece_location" )
    @target_location = input_map.fetch( "target_location" )
    @en_passant      = input_map.fetch( "en_passant", nil )
  end
  
  def valid_input?
    [piece_location, target_location].
      all? { |input| input =~ VALID_USER_MOVE_INPUT }
  end
  
  def parsed_input
    if en_passant
      starting_input_map.merge( "en_passant" => "e.p." )
    else
      starting_input_map.merge( "en_passant" => "" )
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
end