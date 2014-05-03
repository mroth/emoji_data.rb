require 'rspec'
require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec'
  add_filter '/.bundle'
end

require 'emoji_data'
include EmojiData

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
