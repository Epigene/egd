
class Egd::FenBuilder
  # This service takes in a FEN string and a chess move in algebraic notation.
  # Outputs the FEN of the resulting position

  attr_reader :start_fen, :move

  NULL_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".freeze

  # Egd::FenBuilder.new(start_fen: nil, move:).call
  def initialize(start_fen: nil, move:)
    @start_fen = start_fen || NULL_FEN
    @move = move.gsub(%r'\A\d+\.\s*\.*\s*', "")
  end

  def call
    @fen ||= PGN::FEN.new(start_fen).to_position.move(move).to_fen.to_s
  end
end
