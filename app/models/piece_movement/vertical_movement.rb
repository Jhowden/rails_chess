module PieceMovement
  module VerticalMovement
    def find_possible_vertical_spaces( file, rank, piece, counter )
      possible_moves = []
      vertical_counter = counter
      while legal_move?( rank + vertical_counter, file )
        if empty_space?( file, rank + vertical_counter )
          possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + vertical_counter )]
        elsif different_team?( file, rank + vertical_counter, piece )
          possible_moves << [convert_to_file_position( file ), convert_to_rank_position( rank + vertical_counter )]
          break
        else
          break
        end
        vertical_counter += counter
      end
      possible_moves
    end
  end
end