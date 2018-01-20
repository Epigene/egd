class Egd::FenToBoard
  # this service parses a FEN string into a hash-representation of a chess board and pieces
  # So you can do
  # board = Egd::FenToBoard.new(fen_string)
  # board["b3"] #=> "P" # as in white pawn

  attr_reader :fen

  LETTER_VALUES = %w|_ a b c d e f g h|.freeze


  # Egd::FenToBoard.new(fen_string)["b2"]
  def initialize(fen)
    @fen = fen
  end

  def [](square)
    board_hash[square]
  end

  def boardline
    # this replaces numbers with corresponding amount of dashes
    @boardline ||= parsed_fen[:board].gsub(%r'\d') do |match|
      "-" * match.to_i
    end.gsub("/", "")
  end #=> "rnbqkbnrpppp...."

  private
    def parsed_fen
      @parsed_fen ||= Egd::Procedures.parse_fen(fen)
    end

    def board_hash
      return @board_hash if defined?(@board_hash)

      look_up_square_behavior = ->(hash, key) {
        hash[key] = boardline[
          Egd::Procedures.square_to_fen_index(key) - 1
        ]
      }

      @board_hash = Hash.new(&look_up_square_behavior)
    end

end
