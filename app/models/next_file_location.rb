class NextFileLocation
  NEXT_FILE_LOCATION = 1

  def self.check_space_adjacent_space( position )
    position.file_position_converter + NEXT_FILE_LOCATION
  end
end