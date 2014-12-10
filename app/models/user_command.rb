require "parsed_input/standard"
require "parsed_input/en_passant"
require "parsed_input/castle"

class UserCommand
  VALID_USER_MOVE_INPUT = /^[a-h]{1}[1-8]{1}$/
  BLANK_LOCATION = ""
  
  attr_reader :piece_location, :target_location, :en_passant, :castle_input
  
  def initialize input_map
    @piece_location    = input_map.fetch( "piece_location" )
    @target_location   = input_map.fetch( "target_location" )
    @en_passant        = input_map.fetch( "en_passant", nil )
    @castle_input      = input_map.fetch( "castle", nil)
  end
  
  def valid_input?
    return false if incorrect_input?
    
    castle_input ||
      [piece_location, target_location].
        all? { |input| input =~ VALID_USER_MOVE_INPUT }
  end
  
  def get_input
    if en_passant
      ParsedInput::EnPassant.new starting_input_map
    elsif castle_input
      ParsedInput::Castle.new castle_input
    else
      ParsedInput::Standard.new starting_input_map
    end
  end
  
  private
  
  def starting_input_map
    return @input_map if @input_map
    
    @input_map = {
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
    castle_input && target_location != BLANK_LOCATION || 
      castle_input && piece_location != BLANK_LOCATION
  end
  
  def castle_and_en_passant_input?
    castle_input && en_passant
  end
  
  def incorrect_input?
    castle_and_location_input? || castle_and_en_passant_input?
  end
end