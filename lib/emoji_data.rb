require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData
  GEM_ROOT = File.join(File.dirname(__FILE__), '..')
  RAW_JSON = IO.read(File.join(GEM_ROOT, 'vendor/emoji-data/emoji.json'))
  EMOJI_MAP = JSON.parse( RAW_JSON )
  EMOJI_CHARS = EMOJI_MAP.map { |em| EmojiChar.new(em) }

  def self.all
    EMOJI_CHARS
  end

  def self.chars
    @chars ||= EMOJI_CHARS.map(&:char)
  end

  def self.codepoints
    @codepoints ||= EMOJI_CHARS.map(&:unified)
  end

  def self.char_to_unified(char)
    char.codepoints.to_a.map {|i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  def self.unified_to_char(cp)
    find_by_unified(cp).char
  end

  def self.find_by_unified(cp)
    EMOJI_CHARS.detect { |ec| ec.unified == cp.upcase }
  end

  def self.find_by_str(str)
    matches = EMOJI_CHARS.select { |ec| str.include? ec.char }
    matches.sort_by { |matched_char| str.index(matched_char.char) }
  end

  def self.find_by_name(name)
    # self.all.select { |char| char.name.include? name.upcase }
    self.find_by_value(:name, name.upcase)
  end

  def self.find_by_short_name(short_name)
    # self.all.select { |char| char.short_name.include? name.downcase }
    self.find_by_value(:short_name, short_name.downcase)
  end

  protected
  def self.find_by_value(field,value)
    self.all.select { |char| char.send(field).include? value }
  end

end
