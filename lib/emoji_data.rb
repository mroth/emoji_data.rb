require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData
  RAW_JSON = IO.read('vendor/emoji-data/emoji.json')
  EMOJI_MAP = JSON.parse( RAW_JSON )
  EMOJI_CHARS = EMOJI_MAP.map { |em| EmojiChar.new(em) }

  def self.chars
    @chars ||= self.codepoints.map { |cp| Emoji.codepoint_to_char(cp) }
  end

  def self.codepoints
    @codepoints ||= EMOJI_MAP.map { |es| es['unified'] }
  end

  def self.char_to_codepoint(char)
    char.codepoints.to_a.map {|i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  def self.codepoint_to_char(cp)
    find_by_codepoint(cp).to_char
  end

  def self.find_by_codepoint(cp)
    EMOJI_CHARS.detect { |ec| ec.unified == cp }
  end
end
