require "digest"
require "pgn"

require "egd/procedures"
require "egd/fen_builder"
require "egd/fen_to_board"
require "egd/fen_difference_discerner"
require "egd/pgn_parser"
require "egd/version"

module Egd
  ROW_LENGTH = 8.freeze
  COLUMN_HEIGHT = 8.freeze
  SAN_CHESS_PIECES = %w|R N B Q K|.freeze

  def self.root
    Pathname.new(File.expand_path('../..', __FILE__))
  end

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
      @to_h["game_tags"] = game_tags

      @previous_fen = Egd::FenBuilder::NULL_FEN

      moves.each_with_object(@to_h) do |move, mem|
        transition_key = "#{move[%r'\A\d+']}#{move.match?(%r'\.\.') ? "b" : "w"}" #=> "1w"

        puts "-> move '#{move}'" # DEBUG

        end_fen = Egd::FenBuilder.new(start_fen: @previous_fen, move: move).call

        current_transition = {
          "start_position" => {
            "fen" => @previous_fen,
            "features" => "TODO",
          },
          "move" => {
            "player" => transition_key[%r'\D\z'], #=> "w"
            "san" => move.match(%r'\A(?:\d+\.(?:\s*\.\.)?\s+)(?<san>\S+)\z')[:san], #=> "e4"
          }.merge(
            Egd::FenDifferenceDiscerner.new(start_fen: @previous_fen, end_fen: end_fen).call
          ),
          "end_position" => {
            "fen" => end_fen,
            "features" => "TODO"
          }
        }

        # leave this breadcrumb for next run through loop
        @previous_fen = current_transition.dig("end_position", "fen")

        mem[transition_key] = current_transition
      end
    end

    def to_json
      to_h.to_json
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

      def moves_meta_tags(move, previous_diad)
        {
          piece: "p", # [K, Q, R, N, Bl, Bd, p]
          move_type: :move, # [:move. :capture, :castle, :promotion]
          captured_piece: "Q", # [Q, R, N, Bl, Bd, p]
          check: true, # false
          promotion: "Q"
        }
      end

      def parsed_pgn
        @parsed_pgn ||= Egd::PgnParser.new(pgn).call
      end

  end
end
