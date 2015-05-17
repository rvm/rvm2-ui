require "coveralls"
require "simplecov"

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter,
  ]
  command_name "Unit Tests"
  add_filter "/test/"
  add_filter "/demo/"
end

Coveralls.noisy = true unless ENV['CI']

gem "minitest"
require 'minitest/autorun'
require 'minitest/unit'

Dir["lib/**/*.rb"].each{|file|
  file = file.split(/lib\//).last
  require file
}
