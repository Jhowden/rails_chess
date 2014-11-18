require "next_file_location"
require "previous_file_location"

class FileCheckerFactory
  def self.create_for( position, navigation )
    if const_defined?( "#{navigation.to_s.capitalize}FileLocation" )
      const_get("#{navigation.to_s.capitalize}FileLocation" ).check_space_adjacent_space( position )
    else
      raise NameError, "#{navigation.to_s.capitalize}FileLocation is not a valid constant."
    end
  end
end