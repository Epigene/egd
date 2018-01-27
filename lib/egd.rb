require "digest"
require "pgn"

require "egd/procedures"
require "egd/fen_builder"
require "egd/fen_to_board"
require "egd/fen_difference_discerner"
require "egd/position_feature_discerner"
require "egd/pgn_parser"
require "egd/builder"
require "egd/version"

module Egd
  ROW_LENGTH = 8.freeze
  COLUMN_HEIGHT = 8.freeze
  SAN_CHESS_PIECES = %w|R N B Q K|.freeze

  def self.root
    Pathname.new(File.expand_path('../..', __FILE__))
  end
end
