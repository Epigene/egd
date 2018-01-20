# rspec spec/egd/procedures_spec.rb
RSpec.describe Egd::Procedures do
  describe ".parse_fen(fen)" do
    subject(:fen_pieces) { described_class.parse_fen(fen) }

    let(:fen) { Egd::FenBuilder::NULL_FEN }

    it "splits the FEN on whitespace and returns a hash of pieces obtained" do
      expect(fen_pieces).to eq(
        {
          board: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
          castling: "KQkq",
          ep_square: "-",
          fullmove: "1",
          halfmove: "0",
          to_move: "w",
        }
      )
    end
  end

  describe ".square_to_fen_index(square)" do
    subject { described_class.square_to_fen_index(square) }

    context "when square is a8" do
      let(:square) { "a8" }

      it { is_expected.to eq(1) }
    end

    context "when square is h1" do
      let(:square) { "h1" }

      it { is_expected.to eq(64) }
    end

    context "when square is e4" do
      let(:square) { "e4" }

      it { is_expected.to eq(37) }
    end
  end

  describe ".fen_index_to_square(index)" do
    subject { described_class.fen_index_to_square(index) }

    context "when index is 1, the first square" do
      let(:index) { 1 }

      it { is_expected.to eq("a8") }
    end

    context "when index is 3" do
      let(:index) { 3 }

      it { is_expected.to eq("c8") }
    end

    context "when index is 8" do
      let(:index) { 8 }

      it { is_expected.to eq("h8") }
    end

    context "when index is 9" do
      let(:index) { 9 }

      it { is_expected.to eq("a7") }
    end

    context "when index is 56" do
      let(:index) { 56 }

      it { is_expected.to eq("h2") }
    end

    context "when index is 64, the last square" do
      let(:index) { 64 }

      it { is_expected.to eq("h1") }
    end
  end

  describe ".square_color(square)" do
    subject { described_class.square_color(square) }

    context "when called with a8" do
      let(:square) { "a8" }

      it { is_expected.to eq("w") }
    end

    context "when called with a8" do
      let(:square) { "d4" }

      it { is_expected.to eq("b") }
    end

    context "when called with h1" do
      let(:square) { "h1" }

      it { is_expected.to eq("w") }
    end
  end

end

