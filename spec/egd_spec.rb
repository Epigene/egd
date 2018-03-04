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
end
