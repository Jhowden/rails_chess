module ParsedInput
  class Standard
    attr_reader :input_map
    
    def initialize input_map
      @input_map = input_map
    end
    
    def input
      input_map
    end
  end
end