class BoardJsonifier
  def self.jsonify_board( board )
    transformed_board = transform_board( board )
    JSON.generate transformed_board
  end

  private
  
  def self.transform_board board
    dup_board = board.dup
    dup_board.each do |row|
      row.map! do |location|
        transform_location location unless location.nil?
      end
    end
  end
  
  def self.transform_location location
    if location.respond_to? :checkmate
      { "klass"        => location.class.to_s,
        "attributes"   => { 
          "file"         => location.position.file,
          "rank"         => location.position.rank,
          "team"         => location.team,
          "captured"     => location.captured,
          "move_counter" => location.move_counter,
          "checkmate"    => location.checkmate
        } 
      }
    elsif location.respond_to? :orientation
      { "klass"                      => location.class.to_s,
        "attributes"                 => { 
          "file"                       => location.position.file,
          "rank"                       => location.position.rank,
          "team"                       => location.team,
          "captured"                   => location.captured,
          "move_counter"               => location.move_counter,
          "orientation"                => location.orientation,
          "capture_through_en_passant" => location.capture_through_en_passant
        } 
      }
    else
      { "klass"        => location.class.to_s,
        "attributes"   => { 
          "file"         => location.position.file,
          "rank"         => location.position.rank,
          "team"         => location.team,
          "captured"     => location.captured,
          "move_counter" => location.move_counter
        } 
      }
    end
  end
end