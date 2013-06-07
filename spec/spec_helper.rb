require 'rspec'
require 'emoji_data'
include EmojiData

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
