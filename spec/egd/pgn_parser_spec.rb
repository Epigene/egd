# rspec spec/egd/pgn_parser_spec.rb
RSpec.describe Egd::PgnParser do
  describe "#call(pgn_content)" do
    subject { described_class.new(pgn).call }

    context "when called with the 01 pgn" do
      let(:pgn) { example_pgn("01") }

      it "parses an incomplete game correctly" do
        expect(subject).to eq(
          {
            :moves=> [
              {:num=>1, :w=>"e4", :b=>"a6"},
              {:num=>2, :w=>"Bc4", :b=>"a5"},
              {:num=>3, :w=>"Ne2", :b=>"a4"},
              {:num=>4, :w=>"e5", :b=>"f5"},
              {:num=>5, :w=>"exf6"}
            ]
          }
        )
      end
    end

    context "when called with the 02 pgn" do
      let(:pgn) { example_pgn("02") }

      it "parses an complete game with deep comments correctly" do
        expect(subject).to match({
          game_tags: hash_including(
            "Event" => "Eurotel Trophy"
          ),
          :moves=> array_including(
            {:num=>1, :w=>"e4", :b=>"c5"},
            {:num=>2, :w=>"Nf3", :b=>"Nc6"},
            # ...
            {:num=>44, :w=>"Bc4", :b=>"Rxe4"},
            {:num=>45, :w=>"Bd5", :b=>"Rf4"}
          )
        })
      end
    end

    context "when called with the 03 pgn" do
      let(:pgn) { example_pgn("03") }

      it "parses a deeply nested PGN correctly" do
        expect(subject).to match({
          :moves=> array_including(
            {:num=>1, :w=>"e4", :b=>"c5"},
            {:num=>2, :w=>"e5"}
          )
        })
      end
    end

  end
end
