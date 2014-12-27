module PieceMovement
  module SurroundingMovement
    def find_surrounding_spaces( file, rank, piece, modifier_array )
      valid_moves = []

      modifier_array.each do |file_mod, rank_mod|
        new_rank = rank + rank_mod
        new_file = file + file_mod
        
        if legal_move?( new_file, new_rank ) && valid_location?( new_file, new_rank, piece )
          valid_moves << [convert_to_file_position( new_file ), convert_to_rank_position( new_rank )]
        end
      end

      valid_moves
    end
  end
end