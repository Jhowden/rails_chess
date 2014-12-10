module ParsedInput
  class EnPassant
    attr_reader :input_map
    
    EN_PASSANT_MAP = { "en_passant" => "e.p." }
    
    def initialize input_map
      @input_map = input_map
    end
    
    def input
      input_map.merge EN_PASSANT_MAP
    end
  end
end