class Egd::PositionFeatureDiscerner
  # This service takes in a move and the resulting FEN string
  # and outputs a hash of features of the resulting position

  # Currently minimal function,
  # Only looks at supplied move and tells whether the position is a check or checkmate.

  attr_reader :move, :end_fen

  def initialize(move:, end_fen:)
    @move = move
    @end_fen = end_fen
  end

  def call
    return @features if defined?(@features)

    @features = {}

    @features.merge!("check" => true, "checkmate" => true) if move[%r'#\z']
    @features.merge!("check" => true) if move[%r'\+\z']

    @features
  end
end
