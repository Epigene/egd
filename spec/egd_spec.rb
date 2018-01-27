# rspec spec/egd_spec.rb
RSpec.describe Egd do
  it "has a version number" do
    expect(Egd::VERSION).not_to be_nil
  end

  describe ".root" do
    it "returns the root of the project" do
      # may fail if you cloned to a different dir
      expect(Egd.root.to_s).to match("egd")
    end
  end

  describe Egd::Builder do
    describe "#to_h" do
      subject(:hash) { Egd::Builder.new(pgn).to_h }

      context "when initialized with the Readme 00 PGN" do
        let(:pgn) { example_pgn("00") }

        it "returns the EGD hash representation of the game" do
          expect(hash).to eq(
            {
              "game_tags" => {},
              "moves" => {
                "1w"=>{
                  "start_position"=>{
                    "fen"=>"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
                    "features"=>{}
                  },
                  "move"=>{
                    "player"=>"w", "san"=>"e4", "lran"=>"e2-e4", "from_square"=>"e2",
                    "to_square"=>"e4", "piece"=>"p", "move_type"=>"move"
                  },
                  "end_position"=>{
                    "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
                    "features"=>{}
                  }
                },
                "1b"=>{
                  "start_position"=>{
                    "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
                    "features"=>{}
                  },
                  "move"=>{
                    "player"=>"b", "san"=>"e5", "lran"=>"e7-e5",
                    "from_square"=>"e7", "to_square"=>"e5", "piece"=>"p",
                    "move_type"=>"move"
                  },
                  "end_position"=>{
                    "fen"=>"rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2",
                    "features"=>{}
                  }
                }
              }
            }
          )
        end
      end

      context "when initialized with the 02 PGN, a real immortal game" do
        let(:pgn) { example_pgn("02") }

        it "returns the EGD hash representation of the game" do
          expect(hash).to match(
            {
              "game_tags" => {
                "Event"=>"Eurotel Trophy",
                "Site"=> "Prague CZE",
                "Date"=> "2002.04.30",
                "Round"=> "2.1",
                "White"=> "Polgar, Judit",
                "Black"=> "Kasparov, Garri",
                "Result"=> "0-1",
                "ECO"=> "B33",
                "WhiteElo"=> "2677",
                "BlackElo"=> "2838",
                "EventDate"=> "2002.04.28",
                "Annotator"=> "Hathaway, Mark"
              },
              "moves" => hash_including(
                "1w"=> {
                  "start_position"=> {
                    "fen"=>"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
                    "features"=>{}
                  },
                  "move"=> {
                    "player"=>"w", "san"=>"e4", "lran"=>"e2-e4",
                    "from_square"=>"e2", "to_square"=>"e4", "piece"=>"p",
                    "move_type"=>"move"
                  },
                  "end_position"=> {
                    "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
                    "features"=>{}
                  }
                },
                "1b"=> {
                  "start_position"=> {
                    "fen"=>"rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1",
                    "features"=>{}
                  },
                  "move"=> {
                    "player"=>"b", "san"=>"c5", "lran"=>"c7-c5",
                    "from_square"=>"c7", "to_square"=>"c5", "piece"=>"p",
                    "move_type"=>"move"
                  },
                  "end_position"=> {
                    "fen"=>"rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2",
                    "features"=>{}
                  }
                },

                # ...

                "45w"=> {
                  "start_position"=> {
                    "fen"=>"8/5R1p/6k1/2P1b3/2B1r1b1/5p2/1P6/2K5 w - - 0 45",
                    "features"=>{}
                  },
                  "move"=> {
                    "player"=>"w", "san"=>"Bd5", "lran"=>"Bc4-d5",
                    "from_square"=>"c4", "to_square"=>"d5",
                    "piece"=>"Bl", "move_type"=>"move"
                  },
                  "end_position"=> {
                    "fen"=>"8/5R1p/6k1/2PBb3/4r1b1/5p2/1P6/2K5 b - - 1 45",
                    "features"=>{}
                  }
                },
                "45b"=> {
                  "start_position"=> {
                    "fen"=>"8/5R1p/6k1/2PBb3/4r1b1/5p2/1P6/2K5 b - - 1 45",
                    "features"=>{}
                  },
                  "move"=> {
                    "player"=>"b", "san"=>"Rf4", "lran"=>"Re4-f4",
                    "from_square"=>"e4", "to_square"=>"f4",
                    "piece"=>"R", "move_type"=>"move"
                  },
                  "end_position"=> {
                    "fen"=>"8/5R1p/6k1/2PBb3/5rb1/5p2/1P6/2K5 w - - 2 46",
                    "features"=>{}
                  }
                }
              )
            }
          )
        end
      end

      context "when initialized with the 08 PGN, a real Chess.com game" do
        let(:pgn) { example_pgn("08") }

        it "returns the EGD hash representation of the game" do
          expect(hash).to match(
            {
              "game_tags" => anything,
              "moves" => hash_including(
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
            }
          )
        end
      end

      context "when initialized with the 09 PGN with en-passant capture" do
        let(:pgn) { example_pgn("09") }

        it "returns the EGD hash representation with correct move LRANs and FENs" do
          expect(hash).to match({
            "game_tags" => anything,
            "moves" => hash_including(
              "2b" => {
                "start_position" => anything,
                "move" => {
                  "player" => "b",
                  "san" => "d5",
                  "lran" => "d7-d5",
                  "from_square" => "d7",
                  "to_square" => "d5",
                  "piece" => "p",
                  "move_type" => "move"
                },
                "end_position" => {
                  "fen" => "rnbqkbnr/1pp1pppp/p7/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3",
                  "features" => anything
                }
              },
              "3w" => {
                "start_position" => {
                  "fen" => "rnbqkbnr/1pp1pppp/p7/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3",
                  "features" => anything
                },
                "move" => {
                  "player" => "w",
                  "san" => "exd6",
                  "lran" => "e5xd6",
                  "from_square" => "e5",
                  "to_square" => "d6",
                  "piece" => "p",
                  "move_type" => "ep_capture",
                  "captured_piece" => "p"
                },
                "end_position" => {
                  "fen" => "rnbqkbnr/1pp1pppp/p2P4/8/8/8/PPPP1PPP/RNBQKBNR b KQkq - 0 3",
                  "features" => anything
                }
              }
            )
          })
        end
      end
    end

    describe "#to_json" do
      subject(:json) { Egd::Builder.new(pgn).to_json }

      context "when initialized with 00 PGN" do
        let(:pgn) { example_pgn("00") }

        it "produces the readme JSON" do
          expect(json).to eq(
            "{\"game_tags\":{},\"moves\":{\"1w\":{\"start_position\":"\
            "{\"fen\":\"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR "\
            "w KQkq - 0 1\",\"features\":{}},\"move\":{\"player\":"\
            "\"w\",\"san\":\"e4\",\"lran\":\"e2-e4\",\"from_square\":"\
            "\"e2\",\"to_square\":\"e4\",\"piece\":\"p\",\"move_type\":"\
            "\"move\"},\"end_position\":{\"fen\":\"rnbqkbnr/pppppppp/8/"\
            "8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1\",\"features\":{}}},"\
            "\"1b\":{\"start_position\":{\"fen\":\"rnbqkbnr/pppppppp/8/8/"\
            "4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1\",\"features\":{}},"\
            "\"move\":{\"player\":\"b\",\"san\":\"e5\",\"lran\":\"e7-e5\","\
            "\"from_square\":\"e7\",\"to_square\":\"e5\",\"piece\":\"p\","\
            "\"move_type\":\"move\"},\"end_position\":{\"fen\":\"rnbqkbnr"\
            "/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2\","\
            "\"features\":{}}}}}"
          )
        end
      end

      context "when initialized with 02 PGN, the real deal" do
        let(:pgn) { example_pgn("02") }

        it "JSON-ifies the built hash" do
          expect(json).to match(
            %r'\A{\"game_tags\":{\"Event\":\"Eurotel Trophy.*6\",\"features\":{}}}}}\z'
          )
        end
      end
    end

  end
end
