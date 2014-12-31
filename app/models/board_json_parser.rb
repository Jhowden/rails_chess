class BoardJsonParser
  def self.parse_json_board json_board
    set_pieces_on_board( JSON.parse( json_board ) )
  end
  
  private
  
  def self.set_pieces_on_board json_board
    dup_board = json_board.dup
    dup_board.each do |rank|
      rank.map! do |file|
        build_chess_pieces file unless file.nil?
      end
    end
  end
  
  def self.build_chess_pieces file
    const_get( file["klass"] ).new( file["attributes"] )
  end
end