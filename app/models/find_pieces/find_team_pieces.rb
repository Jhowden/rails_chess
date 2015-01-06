require "board_json_parser"

module FindPieces
  module FindTeamPieces
    def self.find_pieces( team, json_board )
      chess_board = BoardJsonParser.parse_json_board( json_board )
      chess_board.map { |row|
        row.select { |location| !location.nil? && 
          location.team == team &&
            location.captured? == false }
      }.flatten.each { |piece| piece.board = Board.new( chess_board ) }
    end
    
    def self.find_king_piece( team, json_board )
      chess_board = BoardJsonParser.parse_json_board( json_board )
      chess_board.map { |row|
        row.select { |location| !location.nil? && 
          location.class == GamePieces::King && 
            location.team == team }
      }.flatten.each { |piece| piece.board = Board.new( chess_board ) }.
        first
    end
  end
end