module PieceMovement
  module HorizontalMovement
    def find_possible_horizontal_spaces( file, rank, piece, counter )
      valid_moves = []
      horizontal_counter = counter
      while legal_move?( rank, file + horizontal_counter )
        if empty_space?( file + horizontal_counter, rank )
          valid_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank )]
        elsif different_team?( file + horizontal_counter, rank, piece )
          valid_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank )]
          break
        else
          break
        end
        horizontal_counter += counter
      end
      valid_moves
    end
  end
end