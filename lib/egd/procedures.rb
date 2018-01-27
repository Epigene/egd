module Egd
  module Procedures
    # This module has global methods for ease of working with chess data

    extend self

    # Egd::Procedures.parse_fen(fen)
    def parse_fen(fen)
      match = fen.split(%r'\s+') # FEN lines are delimited with whitespace, splitting on that

      {
        board: match[0],
        to_move: match[1],
        castling: match[2],
        ep_square: match[3],
        halfmove: match[4],
        fullmove: match[5]
      }
    end

    # Egd::Procedures.square_to_fen_index("b2")
    def square_to_fen_index(square)
      column = square[0]
      row = square[1]

      row_value = Egd::COLUMN_HEIGHT - row.to_i
      row_value * Egd::ROW_LENGTH + Egd::FenToBoard::LETTER_VALUES.index(column)
    end # a8 -> 1, a7 -> 9, h1 -> 64

    # Egd::Procedures.fen_index_to_square(index)
    def fen_index_to_square(index)
      # 3 -> c8
      row = Egd::COLUMN_HEIGHT - ((index - 1) / Egd::COLUMN_HEIGHT) # => 8

      column_index = index - ((Egd::COLUMN_HEIGHT - row) * Egd::ROW_LENGTH)

      column = Egd::FenToBoard::LETTER_VALUES[column_index] # => "c"

      "#{column}#{row}"
    end # 1 -> "a8", 64 -> "h1"

    # Egd::Procedures.square_color("a7")
    def square_color(square)
      column = square[0] #=> a
      row = square[1] #=> 8

      if %w|a c e g|.include?(column)
        row.to_i.even? ? "w" : "b"
      else
        row.to_i.odd? ? "w" : "b"
      end
    end

  end
end
