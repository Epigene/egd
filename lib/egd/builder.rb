module Egd
  class Builder
    # This is the real deal
    # Takes in a PGN string and returns a Ruby or JSON hash representation of the game in EGD

    attr_reader :pgn

    def initialize(pgn)
      @pgn = pgn
    end

    def to_h
      return @to_h if defined?(@to_h)

      @to_h = {}

      @to_h["game_tags"] = {"Result" => result_from_moves}.merge(game_tags)
      @to_h["moves"] = {}

      @previous_fen = Egd::FenBuilder::NULL_FEN

      moves.each_with_object(@to_h) do |move, mem|
        transition_key = "#{move[%r'\A\d+']}#{move.match?(%r'\.\.') ? "b" : "w"}" #=> "1w"

        san = move.match(%r'\A(?:\d+\.(?:\s*\.\.)?\s+)(?<san>\S+)\z')[:san] #=> "e4"
        end_fen = Egd::FenBuilder.new(start_fen: @previous_fen, move: move).call

        current_transition = {
          "start_position" => {
            "fen" => @previous_fen,
            "features" => {}, # TODO, no features can be discerned before the move yet
          },
          "move" => {
            "player" => transition_key[%r'\D\z'], #=> "w"
            "san" => san,
          }.merge(
            Egd::FenDifferenceDiscerner.new(
              start_fen: @previous_fen, move: san, end_fen: end_fen
            ).call
          ),
          "end_position" => {
            "fen" => end_fen,
            "features" => Egd::PositionFeatureDiscerner.new(
              move: move, end_fen: end_fen
            ).call
          }
        }

        # leave this breadcrumb for next run through loop
        @previous_fen = current_transition.dig("end_position", "fen")

        mem["moves"][transition_key] = current_transition
      end
    end

    def to_json
      @to_json ||= to_h.to_json
    end

    private
      def game_tags
        @game_tags ||= parsed_pgn[:game_tags] || {}
      end

      def moves
        return @moves if defined?(@moves)

        @moves = []

        parsed_pgn[:moves].each do |move_row|
          @moves << "#{move_row[:num]}. #{move_row[:w]}"
          @moves << "#{move_row[:num]}. .. #{move_row[:b]}" if move_row[:b]
        end

        @moves
      end

      def parsed_pgn
        @parsed_pgn ||= Egd::PgnParser.new(pgn).call
      end

      def result_from_moves
        last_move_san = moves.last.split(" ").last #=> c4
        possible_result = pgn.split(last_move_san).last.strip

        possible_result == "" ? "*" : possible_result
      end

  end
end
