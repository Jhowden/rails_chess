module ParsedInput
  class Standard
    attr_reader :input_map
    
    def initialize( input_map )
      @input_map = input_map
    end
    
    def input()
      input_map
    end
    
    def chess_notation()
      piece_file + piece_rank + 
      target_file + target_rank
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