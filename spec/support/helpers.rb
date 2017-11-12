module Helpers
  def example_pgn(id)
    file = Dir.glob(Egd.root + "spec/support/pgn_examples/#{id}*").first

    File.read(file)
  end
end
