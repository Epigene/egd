# rspec spec/egd/fen_to_board_spec.rb
RSpec.describe Egd::FenToBoard do
  describe "#[](square)" do
    subject { board[square] }

    let(:board) { described_class.new(Egd::FenBuilder::NULL_FEN) }

    context "when called on starting board position with a square with a white pawn" do
      let(:square) { "b2" }

      it { is_expected.to eq("P") }
    end

    context "when called on starting board position with a square with a black pawn" do
      let(:square) { "h7" }

      it { is_expected.to eq("p") }
    end

    context "when called on starting board position with no pieces" do
      let(:square) { "d4" }

      it { is_expected.to eq("-") }
    end
  end
end
