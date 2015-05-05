module FindPieces
  module FindTeamPieces
    def self.find_pieces( team, board )
      board.chess_board.map { |row|
        row.select { |location| !location.nil? && 
          location.team == team &&
            location.captured? == false }
      }.flatten.each { |piece| piece.board = board }
    end
    
    def self.find_king_piece( team, board )
      board.chess_board.map { |row|
        row.select { |location| !location.nil? && 
          location.class == GamePieces::King && 
            location.team == team }
      }.flatten.each { |piece| piece.board = board }.
        first
    end

    def self.find_kingside_rook( team, board, file_index, rank_index )
      rook = board.chess_board[rank_index][file_index]
      rook.board = board
      rook
    end
  end
end