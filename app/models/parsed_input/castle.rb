class ParsedInput::Castle
  attr_reader :castle_input
  
  def initialize( castle_input )
    @castle_input = castle_input
  end
  
  def input()
    {"castle" => castle_input}
  end
  
  def chess_notation()
    castle_input
  end
end