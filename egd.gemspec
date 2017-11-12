
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "egd/version"

Gem::Specification.new do |spec|
  spec.name          = "egd"
  spec.version       = Egd::VERSION
  spec.required_ruby_version = '>= 2.4.2'
  spec.authors       = ["Epigene"]
  spec.email         = ["augusts.bautra@gmail.com"]

  spec.summary       = %q|Extended Game Description|
  spec.description   = %q|Convert chess PGNs into Extended Game Description JSON|
  spec.homepage      = "https://github.com/Epigene/egd"
  spec.license       = "BSD"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pgn", "~> 0.2.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency "pry", "~> 0.11.2"
  spec.add_development_dependency "simplecov", "~> 0.15.1"
end
