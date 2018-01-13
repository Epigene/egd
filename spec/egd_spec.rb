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
        it "returns the EGD hash representation of the game" do
          expect(0).to(
            eq(1)
          )
        end
      end

      context "when initialized with the 02 PGN, the real deal" do
        it "returns the EGD hash representation of the game" do
          expect(0).to(
            eq(1)
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
