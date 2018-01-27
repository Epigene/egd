module Egd
  class FenDifferenceDiscerner
    # This service takes in a start and an end FEN string,
    # and the move in SAN,
    # and a tells you what kind of move occured, in more detail than SAN

    # Theoretically a start and end fen would suffice, but having move in SAN,
    # which we do, allows skipping some hard procesing parts.

    attr_reader :start_fen, :move, :end_fen

    # Egd::FenDifferenceDiscerner.new(start_fen:, end_fen:).call
    def initialize(start_fen: nil, move:, end_fen:)
      @start_fen = start_fen || Egd::FenBuilder::NULL_FEN
      @move = move
      @end_fen = end_fen
    end

    def call
      # quickreturn with possible special cases
      case move
      when "O-O"
        return special_case_short_castle(Egd::Procedures.parse_fen(start_fen)[:to_move])
      when "O-O-O"
        return special_case_long_castle(Egd::Procedures.parse_fen(start_fen)[:to_move])
      when %r'\A[a-h]x[a-h]\d' # pawn x pawn, possible en-passant
        return special_case_ep_capture if special_case_ep_capture
      end

      # entering long processing of regular moves

      changes = {
        "lran" => lran, # FEN
        "from_square" => from_square, # FEN # b2
        "to_square" => to_square, # move b3
        "piece" => piece, # move p
        "move_type" => move_type,
      }

      changes.merge!("captured_piece" => captured_piece) if captured_piece
      changes.merge!("promotion" => promotion) if promotion

      changes
    end

    private

      def special_case_ep_capture
        return @ep_capture if defined?(@ep_capture)

        return @ep_capture = false if Egd::Procedures.parse_fen(start_fen)[:ep_square] != to_square

        from = move[0] + (move[-1] == "6" ? "5" : "4")

        @ep_capture = {
          "lran" => "#{from}x#{to_square}", # FEN
          "from_square" => from, # FEN
          "to_square" => to_square, # move
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

      def board1
        @board1 ||= Egd::FenToBoard.new(start_fen)
      end

      def board2
        @board2 ||= Egd::FenToBoard.new(end_fen)
      end

      def changed_squares
        return @changed_squares if defined?(@changed_squares)

        @changed_squares = []

        (1..64).to_a.each do |fen_index|
          i = fen_index - 1

          if board1.boardline[i] != board2.boardline[i]
            square = Egd::Procedures.fen_index_to_square(fen_index)

            @changed_squares << {
              square: square, from: board1.boardline[i], to: board2.boardline[i]
            }
          end
        end

        @changed_squares
      end

      def from_square
        @from_square ||= changed_squares.reject do |hash|
          hash[:square] == to_square
        end.detect do |hash|
          hash[:to] == "-"
        end[:square]
      end

      def to_square
        @to_square ||= move.match(%r'\A(?<basemove>.*\d)(?<drek>.*)?\z')[:basemove][-2..-1]
      end

      def piece
        return @piece if defined?(@piece)

        possible_piece = move[0]

        @piece = (Egd::SAN_CHESS_PIECES.include?(possible_piece) ? possible_piece : "p" )

        @piece << bishop_color(to_square) if @piece == "B"

        @piece
      end

      def move_type
        @move_type ||=
          case move
          when %r'x.*='i
            "promotion_capture"
          when %r'x'i
            "capture"
          when %r'='i
            "promotion"
          else
            "move"
          end
      end

      def captured_piece
        @captured_piece ||=
          if move_type[%r'capture']
            captured_piece = changed_squares.detect do |hash|
              hash[:square] == to_square
            end[:from].upcase

            captured_piece.downcase! if captured_piece[%r'p'i]

            captured_piece << bishop_color(to_square) if captured_piece == "B"

            captured_piece
          else
            nil
          end
      end

      def promotion
        @promotion ||=
          if move_type[%r'promotion']
            promoted_to = move.match(%r'=(?<promo>.)\z')[:promo]

            promoted_to << bishop_color(to_square) if promoted_to == "B"

            promoted_to
          else
            nil
          end
      end

      def lran
        return @lran if defined?(@lran)

        @lran = "#{piece_in_lran(piece)}#{from_square}"

        @lran << (
          captured_piece ?
            "x#{piece_in_lran(captured_piece)}#{to_square}" :
            "-#{to_square}"
        )

        @lran << "=#{promotion[0]}" if promotion

        @lran
      end

      def piece_in_lran(pc)
        pc == "p" ? "" : pc[0]
      end

      def bishop_color(on_square)
        Egd::Procedures.square_color(on_square) == "w" ? "l" : "d"
      end

  end
end
