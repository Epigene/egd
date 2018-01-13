if ENV["USE_COVERALLS"] == "true"
  require 'coveralls'
  Coveralls.wear!
else
  require 'simplecov'
  SimpleCov.start
end
