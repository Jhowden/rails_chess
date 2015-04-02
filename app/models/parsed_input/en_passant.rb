module ParsedInput
  class EnPassant
    attr_reader :input_map
    
    EN_PASSANT_MAP = { "en_passant" => "e.p." }
    
    def initialize( input_map )
      @input_map = input_map
    end
    
    def input()
      input_map.merge EN_PASSANT_MAP
    end
    
    def chess_notation()
      piece_file + piece_rank + 
      target_file + target_rank + 
      EN_PASSANT_MAP["en_passant"]
    end
    
    def piece_file()
      input_map["piece_location"]["file"]
    end
    
    def piece_rank()
      input_map["piece_location"]["rank"]
    end
    
    def target_rank()
      input_map["target_location"]["rank"]
    end
    
    def target_file()
      input_map["target_location"]["file"]
    end
  end
end