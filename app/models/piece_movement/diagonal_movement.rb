module PieceMovement
  module DiagonalMovement
    def find_possible_diagonally_spaces( file, rank, piece, vert_counter, horizont_counter )
      valid_moves = []
      vertical_counter = vert_counter
      horizontal_counter = horizont_counter
      while legal_move?( file + horizontal_counter, rank + vertical_counter )
        if empty_space?( file + horizontal_counter, rank + vertical_counter )
          valid_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank + vertical_counter )]
        elsif different_team?( file + horizontal_counter, rank + vertical_counter, piece )
          valid_moves << [convert_to_file_position( file + horizontal_counter ), convert_to_rank_position( rank + vertical_counter )]
          break
        else
          break
        end
        vertical_counter += vert_counter
        horizontal_counter += horizont_counter
      end
      valid_moves
    end
  end
end