class Egd::FenDifferenceDiscerner
  # This service takes in a start and an end FEN string,
  # and a tells you what kind of move occured

  attr_reader :start_fen, :move, :end_fen

  # Egd::FenDifferenceDiscerner.new(start_fen:, end_fen:).call
  def initialize(start_fen: nil, move:, end_fen:)
    @start_fen = start_fen || Egd::FenBuilder::NULL_FEN
    @move = move
    @end_fen = end_fen
  end

  def call
    case move
    when "O-O"
      return special_case_short_castle(parse_fen(start_fen)[:to_move])
    when "O-O-O"
      return special_case_long_castle(parse_fen(start_fen)[:to_move])
    when %r'\A[a-h]x[a-h]\d' # pawn x pawn, possible en-passant
      return special_case_ep_capture if special_case_ep_capture
    end

    fen1 = parse_fen(start_fen)
    fen2 = parse_fen(end_fen)

    squares = changed_squares(fen1[:board], fen2[:board])

    binding.pry

    {
      "lran" => "TODO", # FEN
      "from_square" => "TODO", # FEN
      "to_square" => "TODO", # move
      "piece" => "TODO", # move
      "move_type" => "TODO", # FEN

      # optionals
      "captured_piece" => "p", # move
      "promotion" => "Q", # move
    }
  end

  private
    def parse_fen(fen)
      match = fen.split(%r'\s+')

      {
        board: match[0],
        to_move: match[1],
        castling: match[2],
        ep_square: match[3],
        halfmove: match[4],
        fullmove: match[5]
      }
    end

    def changed_squares(board1, board2)
      expanded_board2 = expand_board(board2)

      moved_from = ""
      moved_to = ""

      expand_board(board1).split("").each.with_index(0) do |letter, i|
        moved_from +=
          if letter == expanded_board2[i] && letter != "/"
            "-"
          else
            letter
          end
      end

      binding.pry

      moved_from
    end

    def expand_board(board)
      # this replaces numbers with corresponding amount of dashes
      board.gsub(%r'\d') do |match|
        "-" * match.to_i
      end
    end

    def special_case_ep_capture
      return @ep_capture if defined?(@ep_capture)

      return @ep_capture = false if parse_fen(start_fen)[:ep_square] != move[-2..-1]

      from = move[0] + (move[-1] == "6" ? "5" : "4")
      to = move[-2..-1]

      @ep_capture = {
        "lran" => "#{from}x#{to}", # FEN
        "from_square" => from, # FEN
        "to_square" => to, # move
        "piece" => "p", # move
        "move_type" => "ep_capture", # FEN
        "captured_piece" => "p", # move
      }
    end

    def special_case_short_castle(player)
      {
        "lran" => "O-O", # FEN
        "from_square" => (player == "w" ? "e1" : "e8"), # FEN
        "to_square" => (player == "w" ? "g1" : "g8"), # move
        "piece" => "K", # move
        "move_type" => "short_castle", # FEN
      }
    end

    def special_case_long_castle(player)
      {
        "lran" => "O-O-O", # FEN
        "from_square" => (player == "w" ? "e1" : "e8"), # FEN
        "to_square" => (player == "w" ? "c1" : "c8"), # move
        "piece" => "K", # move
        "move_type" => "long_castle", # FEN
      }
    end
end
