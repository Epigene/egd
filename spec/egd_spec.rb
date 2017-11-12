# rspec spec/egd_spec.rb
RSpec.describe Egd do
  it "has a version number" do
    expect(Egd::VERSION).not_to be_nil
  end

  describe ".root" do
    it "returns the root of the project" do
      expect(Egd.root.to_s).to match(
        "egd"
      )
    end
  end

  describe Egd::Builder do
    describe "#to_json" do
      subject { Egd::Builder.new(pgn).to_json }

      context "when initialized with 00 PGN" do
        let(:pgn) { example_pgn("00") }

        it "produces the readme JSON" do
          expect(subject).to eq({

          })
        end
      end

      context "when initialized with 01 PGN" do
        let(:pgn) { example_pgn("01") }

        it " " do
          expect(0).to(
            eq(1)
          )
        end
      end
    end

  end
end
