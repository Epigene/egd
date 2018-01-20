# rspec spec/egd_spec.rb
RSpec.describe Egd do
  it "has a version number" do
    expect(Egd::VERSION).not_to be_nil
  end

  describe ".root" do
    it "returns the root of the project" do
      # may fail if you cloned to a different dir
      expect(Egd.root.to_s).to match(
        "egd"
      )
    end
  end

  describe Egd::Builder do
    describe "#to_h" do
      subject(:hash) { Egd::Builder.new(pgn).to_h }

      context "when initialized with the Readme 00 PGN" do
        let(:pgn) { example_pgn("00") }

        it "returns the EGD hash representation of the game" do
          expect(hash).to(
            eq(1)
          )
        end
      end

      context "when initialized with the 02 PGN, a real immortal game" do
        let(:pgn) { example_pgn("02") }

        it "returns the EGD hash representation of the game" do
          expect(hash).to match(

          )
        end
      end

      context "when initialized with the 08 PGN, a real Chess.com game" do
        let(:pgn) { example_pgn("08") }

        it "returns the EGD hash representation of the game" do
          binding.pry
          expect(hash).to match(
            hash_including(
              "61b" => {
                "start_position" => anything,
                "move" => {
                  "player" => "b",
                  "san" => "Kxb5",
                  "lran" => "Kc4xb5",
                  "from_square" => "c4",
                  "to_square" => "b5",
                  "piece" => "K",
                  "move_type" => "capture",
                  "captured_piece"=>"p"
                },
                "end_position" => anything,
              },
              "62w" => {
                "start_position" => anything,
                "move" => {
                  "player" => "w",
                  "san" => "c8=Q",
                  "lran" => "c7-c8=Q",
                  "from_square" => "c7",
                  "to_square" => "c8",
                  "piece" => "p",
                  "move_type" => "promotion",
                  "promotion"=>"Q"
                },
                "end_position" => anything
              },
              "62b" => {
                "start_position" => anything,
                "move" => {
                  "player" => "b",
                  "san" => "Kb4",
                  "lran" => "Kb5-b4",
                  "from_square" => "b5",
                  "to_square" => "b4",
                  "piece" => "K",
                  "move_type" => "move",
                },
                "end_position" => anything
              },
              "63w" => {
                "start_position" => anything,
                "move" => {
                  "player" => "w",
                  "san" => "Qg4+",
                  "lran" => "Qc8-g4",
                  "from_square" => "c8",
                  "to_square" => "g4",
                  "piece" => "Q",
                  "move_type" => "move",
                },
                "end_position" => {
                  "fen" => anything,
                  "features" => {"check" => true}
                }
              },
              "63b" => {
                "start_position" => anything,
                "move" => {
                  "player" => "b",
                  "san" => "Kb3",
                  "lran" => "Kb4-b3",
                  "from_square" => "b4",
                  "to_square" => "b3",
                  "piece" => "K",
                  "move_type" => "move",
                },
                "end_position" => anything
              },
              "64w" => {
                "start_position" => anything,
                "move" => {
                  "player" => "w",
                  "san" => "Qaa4+",
                  "lran" => "Qa8-a4",
                  "from_square" => "a8",
                  "to_square" => "a4",
                  "piece" => "Q",
                  "move_type" => "move",
                },
                "end_position" => {
                  "fen" => anything,
                  "features" => {"check" => true}
                }
              },
              "64b" => {
                "start_position" => anything,
                "move" => {
                  "player" => "b",
                  "san" => "Kc3",
                  "lran" => "Kb3-c3",
                  "from_square" => "b3",
                  "to_square" => "c3",
                  "piece" => "K",
                  "move_type" => "move",
                },
                "end_position" => anything
              },
              "65w" => {
                "start_position" => anything,
                "move" => {
                  "player" => "w",
                  "san" => "Qgd4#",
                  "lran" => "Qg4-d4",
                  "from_square" => "g4",
                  "to_square" => "d4",
                  "piece" => "Q",
                  "move_type" => "move",
                },
                "end_position" => {
                  "fen" => anything,
                  "features" => {
                    "check" => true,
                    "checkmate" => true
                  }
                }
              },
            )
          )
        end
      end

      context "when initialized with the 09 PGN with en-passant capture" do
        let(:pgn) { example_pgn("09") }

        it "returns the EGD hash representation with correct move LRANs and FENs" do
          expect(hash).to match(
            hash_including(
              "2b" => {
                "start_position" => {
                  fen: anything,
                  features: anything
                },
                "move" => {
                  "san" => "d5",
                  "lran" => "d7-d5",
                  "from_square" => "d7",
                  "to_square" => "d5",
                  "piece" => "p",
                  "move_type" => "move"
                },
                "end_position" => {
                  fen: "rnbqkbnr/1pp1pppp/p7/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3",
                  features: anything
                }
              },
              "3w" => {
                "start_position" => {
                  fen: "rnbqkbnr/1pp1pppp/p7/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3",
                  features: anything
                },
                "move" => {
                  "san" => "exd6",
                  "lran" => "e5xd6",
                  "from_square" => "e5",
                  "to_square" => "d6",
                  "piece" => "p",
                  "move_type" => "ep_capture",
                  "captured_piece" => "p"
                },
                "end_position" => {
                  fen: "rnbqkbnr/1pp1pppp/p2P4/8/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 3",
                  features: anything
                }
              }
            )
          )
        end
      end
    end

    describe "#to_json" do
      subject(:json) { Egd::Builder.new(pgn).to_json }

      context "when initialized with 00 PGN" do
        let(:pgn) { example_pgn("00") }

        it "produces the readme JSON" do
          expect(json).to eq({

          })
        end
      end

      context "when initialized with 02 PGN, the real deal" do
        let(:pgn) { example_pgn("01") }

        it "JSON-ifies the built hash" do
          expect(json).to match(%r'FFf')
        end
      end
    end

  end
end
