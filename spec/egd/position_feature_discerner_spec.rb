# rspec spec/egd/position_feature_discerner_spec.rb
RSpec.describe Egd::PositionFeatureDiscerner do
  describe "#call" do
    subject(:features) { discerner.call }

    let(:discerner) { described_class.new(**options) }

    context "when move results in no special position features" do
      let(:options) do
        {
          move: "d5",
          end_fen: "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2"
        }
      end

      it { is_expected.to eq({}) }
    end

    context "when move results in a check" do
      let(:options) { {move: "axb8=Q+", end_fen: "rQ2kbnr/1p2pppp/2p1b3/q2p4/8/8/P1PPPPPP/RNBQKBNR b KQkq - 0 5"} }

      it { is_expected.to eq({"check" => true}) }
    end

    context "when move results in a checkmate" do
      let(:options) { {move: "Qxc8#", end_fen: "2Q1kbnr/1p2ppp1/q1p4p/3p4/8/8/P1PPPPPP/RNBQKBNR b KQk - 0 8"} }

      it { is_expected.to eq({"check" => true, "checkmate" => true}) }
    end
  end
end

