require "digest"
require "pgn"

require "egd/fen_builder"
require "egd/pgn_parser"
require "egd/version"

module Egd
  def self.root
    Pathname.new(File.expand_path('../..', __FILE__))
  end

  class Builder
    attr_reader :pgn

    def initialize(pgn)
      @pgn = pgn
    end

    def to_json
      moves.map do |move|
        puts "-> move '#{move}'"
        @previous_diad = {
          move: {
            order: "1",
            player: "white",
            algeb: move,
            meta: moves_meta_tags(move, @previous_diad)
          },
          position: {
            "FEN" => Egd::FenBuilder.new(start_fen: @previous_fen, move: move).call,
            meta: {
              "TODO" => true,
            }
          }
        }

        @previous_fen = @previous_diad.dig(:position, "FEN")

        @previous_diad
      end
    end

    private
      def game_tags
        @game_tags ||= parsed_pgn[:game_tags]
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
          piece_moved: "p", # [K, Q, R, N, Bl, Bd, p]
          move_type: :move, # [:move. :capture, :castle]
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
