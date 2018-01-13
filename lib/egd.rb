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
    # This is the real deal
    # Takes in a PGN string and returns a Ruby or JSON hash representation of the game in EGD

    attr_reader :pgn

    def initialize(pgn)
      @pgn = pgn
    end

    def to_h
      return @to_h if defined?(@to_h)

      binding.pry

      @to_h = {}
      @to_h[:game_tags] = game_tags

      @to_h = moves.map do |move|
        puts "-> move '#{move}'"
        @previous_diad = {
          move: {
            order: "1",
            player: "w",
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
