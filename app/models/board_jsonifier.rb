class BoardJsonifier
  def self.jsonify_board( board )
    transformed_board = transform_board( board )
    JSON.generate transformed_board
  end
  
  def self.translate_json_board( json_board )
    set_pieces_on_board( JSON.parse( json_board ) )
  end
  
  private
  
  def self.transform_board board
    dup_board = board.dup
    dup_board.each do |rank|
      rank.map! do |file|
        transform_file file unless file.nil?
      end
    end
  end
  
  def self.transform_file file
    if file.respond_to? :checkmate
      { "klass" => file.class.to_s,
        "attributes" => { file: file.position.file,
        "rank" => file.position.rank,
        "team" => file.team,
        "captured" => file.captured,
        "move_counter" => file.move_counter,
        "checkmate" => file.checkmate } }
    elsif file.respond_to? :orientation
      { "klass" => file.class.to_s,
        "attributes" => { file: file.position.file,
        "rank" => file.position.rank,
        "team" => file.team,
        "captured" => file.captured,
        "move_counter" => file.move_counter,
        "orientation" => file.orientation,
        "capture_through_en_passant" => file.capture_through_en_passant } }
    else
      { "klass" => file.class.to_s,
        "attributes" => { file: file.position.file,
        "rank" => file.position.rank,
        "team" => file.team,
        "captured" => file.captured,
        "move_counter" => file.move_counter } }
    end
  end
  
  def self.set_pieces_on_board board
    dup_board = board.dup
    dup_board.each do |rank|
      rank.map! do |file|
        convert_to_active_record file unless file.nil?
      end
    end
  end
  
  def self.convert_to_active_record file
    const_get( file["klass"] ).new( file["attributes"] )
  end
end