# rspec spec/egd/fen_builder_spec.rb
RSpec.describe Egd::FenBuilder do
  describe "#call(start_fen: nil, move:)" do
    subject { described_class.new(**args).call }

    context "when initialized without a starting fen" do
      let(:args) { {move: "a3"} }

      it "assumes its the first move from a standart chess starting position" do
        expect(subject).to(
          eq("rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR b KQkq - 0 1")
        )
      end
    end

    context "when initialized without a move" do
      let(:args) { {} }

      it "returns the unchanged fen it was initialized with" do
        expect(subject).to eq(described_class::NULL_FEN)
      end
    end

    context "when move is given with order number" do
      let(:args) { {move: "1. a3"} }

      it "works as if the number was not given" do
        expect(subject).to(
          eq("rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR b KQkq - 0 1")
        )
      end
    end

    context "when making a simple piece move" do
      let(:args) { {start_fen: "rnbqkbnr/pppppppp/8/8/8/P7/1PPPPPPP/RNBQKBNR b KQkq - 0 1", move: "Nf6"} }

      it "moves the piece correctly" do
        expect(subject).to(
          eq("rnbqkb1r/pppppppp/5n2/8/8/P7/1PPPPPPP/RNBQKBNR w KQkq - 1 2")
        )
      end
    end

    context "when making a double pawn push" do
      let(:args) { {start_fen: "rnbqkbnr/1ppppppp/p7/4P3/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 2", move: "f5"} }

      it "marks en-passant suqare correcly" do
        expect(subject).to(
          eq("rnbqkbnr/1pppp1pp/p7/4Pp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3")
        )
      end
    end

    context "when making an en-passant capture" do
      let(:args) { {start_fen: "rnbqkbnr/1pppp1pp/p7/4Pp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3", move: "exf6"} }

      it "marks the removal of pawn and landing of capturing pawn correcly" do
        expect(subject).to(
          eq("rnbqkbnr/1pppp1pp/p4P2/8/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 3")
        )
      end
    end

    context "when castling" do
      let(:args) { {start_fen: "rnbqk2r/pp1p1pp1/2Pbpn1p/8/2B5/P3P3/1PP2PPP/RNBQK1NR b KQkq - 2 6", move: "O-O"} }

      it "marks movement of king and rook correcly" do
        expect(subject).to(
          eq("rnbq1rk1/pp1p1pp1/2Pbpn1p/8/2B5/P3P3/1PP2PPP/RNBQK1NR w KQ - 3 7")
        )
      end
    end

    context "when making a regular capture" do
      let(:args) { {start_fen: "rnbq1rk1/pp1p1pp1/2Pbpn1p/8/2B5/P3P3/1PP2PPP/RNBQK1NR w KQ - 3 7", move: "Bxe6"} }

      it "marks the replacement correctly" do
        expect(subject).to(
          eq("rnbq1rk1/pp1p1pp1/2PbBn1p/8/8/P3P3/1PP2PPP/RNBQK1NR b KQ - 0 7")
        )
      end
    end

  end
end
