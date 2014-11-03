class BoardJsonifier
  def self.jsonify_board( board )
    transformed_board = transform_board board
    transformed_board.to_json
  end
  
  private
  
  def self.transform_board board
    dup_board = board.dup
    dup_board.each do |rank|
      rank.map! do |file|
        unless file.nil?
          transform_file file
        end
      end
    end
  end
  
  def self.transform_file file
    if file.respond_to? :checkmate
      { file.class => { file: file.position.file,
        rank: file.position.rank,
        team: file.team,
        captured: file.captured,
        move_counter: file.move_counter,
        checkmate: file.checkmate } }
    elsif file.respond_to? :orientation
      { file.class => { file: file.position.file,
        rank: file.position.rank,
        team: file.team,
        captured: file.captured,
        move_counter: file.move_counter,
        orientation: file.orientation,
        capture_through_en_passant: file.capture_through_en_passant } }
    else
      { file.class => { file: file.position.file,
        rank: file.position.rank,
        team: file.team,
        captured: file.captured,
        move_counter: file.move_counter } }
    end
  end
end