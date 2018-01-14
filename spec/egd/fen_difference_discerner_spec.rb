# rspec spec/egd/fen_difference_discerner_spec.rb
RSpec.describe Egd::FenDifferenceDiscerner do
  describe "#call" do
    subject(:the_difference) { discerner.call }

    let(:discerner) { described_class.new(start_fen: fen1, move: move, end_fen: fen2) }

    context "when fen difference is produced by a pawn push, but start fen is not specified" do
      let(:fen1) { nil }
      let(:move) { "b3" }
      let(:fen2) { "rnbqkbnr/pppppppp/8/8/8/1P6/P1PPPPPP/RNBQKBNR b KQkq - 0 1" }

      it "returns a hash of the difference / move as if it happened from initial position" do
        expect(the_difference).to eq(
          {
            "lran" => "b2-b3",
            "from_square" => "b2",
            "to_square" => "b3",
            "piece" => "p",
            "move_type" => "move",
          }
        )
      end
    end

    context "when fen difference is produced by a pawn push" do
      let(:fen1) { "r2q1rk1/1ppbb2p/p1n1pnp1/3p4/3P1B2/2NQPN2/PPP1BPP1/R3K2R w KQ - 0 11" }
      let(:move) { "b4" }
      let(:fen2) { "r2q1rk1/1ppbb2p/p1n1pnp1/3p4/1P1P1B2/2NQPN2/P1P1BPP1/R3K2R b KQ - 0 11" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "b2-b4",
            "from_square" => "b2",
            "to_square" => "b4",
            "piece" => "p",
            "move_type" => "move",
          }
        )
      end
    end

    context "when fen difference is produced by a queen move" do
      let(:fen1) { "1B4k1/2pbbr1p/2n1pnp1/3p4/3P1B2/2NQPN2/P1P1BPP1/R3K2R w KQ - 1 16" }
      let(:move) { "Qa6" }
      let(:fen2) { "1B4k1/2pbbr1p/Q1n1pnp1/3p4/3P1B2/2N1PN2/P1P1BPP1/R3K2R b KQ - 2 16" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "Qd3-a6",
            "from_square" => "d3",
            "to_square" => "a6",
            "piece" => "Q",
            "move_type" => "move",
          }
        )
      end
    end

    context "when fen difference is produced by a pawn x pawn capture" do
      let(:fen1) { "r2q1rk1/1ppbbp1p/p1n1pnP1/3p4/3P1B2/2NQPN2/PPP1BPP1/R3K2R b KQ - 0 10" }
      let(:move) { "fxg6" }
      let(:fen2) { "r2q1rk1/1ppbb2p/p1n1pnp1/3p4/3P1B2/2NQPN2/PPP1BPP1/R3K2R w KQ - 0 11" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "f7xg6",
            "from_square" => "f7",
            "to_square" => "g6",
            "piece" => "p",
            "move_type" => "capture",
            "captured_piece" => "p",
          }
        )
      end
    end

    context "when fen difference is produced by a pawn x pawn ep_capture" do
      let(:fen1) { "r2q1rk1/1ppbbp1p/p1n1pn2/3p2pP/3P1B2/2NQPN2/PPP1BPP1/R3K2R w KQ g6 0 10" }
      let(:move) { "hxg6" }
      let(:fen2) { "r2q1rk1/1ppbbp1p/p1n1pnP1/3p4/3P1B2/2NQPN2/PPP1BPP1/R3K2R b KQ - 0 10" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "h5xg6",
            "from_square" => "h5",
            "to_square" => "g6",
            "piece" => "p",
            "move_type" => "ep_capture",
            "captured_piece" => "p",
          }
        )
      end
    end

    context "when fen difference is produced by a O-O shortcastle" do
      let(:fen1) { "r2qk2r/pppbbppp/2n1pn2/3p4/3P1B2/2NQPN2/PPP1BPPP/R3K2R b KQkq - 4 7" }
      let(:move) { "O-O" }
      let(:fen2) { "r2q1rk1/pppbbppp/2n1pn2/3p4/3P1B2/2NQPN2/PPP1BPPP/R3K2R w KQ - 5 8" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "O-O",
            "from_square" => "e8",
            "to_square" => "g8",
            "piece" => "K",
            "move_type" => "short_castle",
          }
        )
      end
    end

    context "when fen difference is produced by a O-O-O longcastle" do
      let(:fen1) { "r1bqkb1r/ppp2ppp/2n1pn2/3p4/3P1B2/2NQ4/PPP1PPPP/R3KBNR w KQkq - 2 5" }
      let(:move) { "O-O-O" }
      let(:fen2) { "r1bqkb1r/ppp2ppp/2n1pn2/3p4/3P1B2/2NQ4/PPP1PPPP/2KR1BNR b kq - 3 5" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "O-O-O",
            "from_square" => "e1",
            "to_square" => "c1",
            "piece" => "K",
            "move_type" => "long_castle",
          }
        )
      end
    end

    context "when fen difference is produced by a NxB capture" do
      let(:fen1) { "rn1qkbnr/ppp1pppp/3p4/5b2/7N/8/PPPPPPPP/RNBQKB1R w KQkq - 2 3" }
      let(:move) { "Nxf5" }
      let(:fen2) { "rn1qkbnr/ppp1pppp/3p4/5N2/8/8/PPPPPPPP/RNBQKB1R b KQkq - 0 3" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "Nh4xBf5",
            "from_square" => "h4",
            "to_square" => "f5",
            "piece" => "N",
            "move_type" => "capture",
            "captured_piece" => "Bl",
          }
        )
      end
    end

    context "when fen difference is produced by a Bb5xBd7 capture" do
      let(:fen1) { "rn1qkbnr/pppbpppp/8/1B1p4/4P3/8/PPPP1PPP/RNBQK1NR w KQkq - 2 3" }
      let(:move) { "Bxd7" }
      let(:fen2) { "rn1qkbnr/pppBpppp/8/3p4/4P3/8/PPPP1PPP/RNBQK1NR b KQkq - 0 3" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "Bb5xBd7",
            "from_square" => "b5",
            "to_square" => "d7",
            "piece" => "Bl",
            "move_type" => "capture",
            "captured_piece" => "Bl",
          }
        )
      end
    end

    context "when fen difference is produced by a a7-a8=Q promotion" do
      let(:fen1) { "3q1rk1/P1pbb2p/2n1p1p1/3p3n/3P1B2/2NQPN2/P1P1BPP1/R3K2R w KQ - 1 15" }
      let(:move) { "a8=Q" }
      let(:fen2) { "Q2q1rk1/2pbb2p/2n1p1p1/3p3n/3P1B2/2NQPN2/P1P1BPP1/R3K2R b KQ - 0 15" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "a7-a8=Q",
            "from_square" => "a7",
            "to_square" => "a8",
            "piece" => "p",
            "move_type" => "promotion",
            "promotion" => "Q",
          }
        )
      end
    end

    context "when fen difference is produced by a a7xb8=B promotion" do
      let(:fen1) { "1q3rk1/P1pbb2p/2n1pnp1/3p4/3P1B2/2NQPN2/P1P1BPP1/R3K2R w KQ - 1 15" }
      let(:move) { "axb8=Q" }
      let(:fen2) { "1B3rk1/2pbb2p/2n1pnp1/3p4/3P1B2/2NQPN2/P1P1BPP1/R3K2R b KQ - 0 15" }

      it "returns a hash of the difference / move" do
        expect(the_difference).to eq(
          {
            "lran" => "a7xb8=B",
            "from_square" => "a7",
            "to_square" => "b8",
            "piece" => "p",
            "move_type" => "promotion",
            "promotion" => "Bd",
          }
        )
      end
    end

  end
end
