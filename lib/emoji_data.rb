require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData
  GEM_ROOT = File.join(File.dirname(__FILE__), '..')
  RAW_JSON = IO.read(File.join(GEM_ROOT, 'vendor/emoji-data/emoji.json'))
  EMOJI_MAP = JSON.parse( RAW_JSON )
  EMOJI_CHARS = EMOJI_MAP.map { |em| EmojiChar.new(em) }

  #
  # construct hashmap for fast precached lookups for `.from_unified`
  #
  EMOJICHAR_UNIFIED_MAP = Hash[EMOJI_CHARS.map { |u| [u.unified, u] }]
  EMOJI_CHARS.select(&:variant?).each do |char|
    char.variations.each do |variant|
      EMOJICHAR_UNIFIED_MAP.merge! Hash[variant,char]
    end
  end

  def self.all
    EMOJI_CHARS
  end

  def self.all_doublebyte
    EMOJI_CHARS.select(&:doublebyte?)
  end

  def self.all_with_variants
    EMOJI_CHARS.select(&:variant?)
  end

  def self.chars(options={})
    options = {include_variants: false}.merge(options)

    normals = EMOJI_CHARS.map { |c| c.render({variant_encoding: false}) }
    extras  = self.all_with_variants.map { |c| c.render({variant_encoding: true}) }

    if options[:include_variants]
      return normals + extras
    end
    normals
  end

  def self.codepoints(options={})
    options = {include_variants: false}.merge(options)

    if options[:include_variants]
      return EMOJI_CHARS.map(&:unified) + self.all_with_variants.map {|c| c.variant}
    end
    EMOJI_CHARS.map(&:unified)
  end

  def self.char_to_unified(char)
    char.codepoints.to_a.map { |i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  def self.unified_to_char(cp)
    EmojiChar::unified_to_char(cp)
  end

  def self.from_unified(cp)
    EMOJICHAR_UNIFIED_MAP[cp.upcase]
  end

  FBS_REGEXP = Regexp.new("(?:#{EmojiData.chars({include_variants: true}).join("|")})")
  def self.scan(str)
    matches = str.scan(FBS_REGEXP)
    matches.map { |m| EmojiData.from_unified(EmojiData.char_to_unified(m)) }
  end

  def self.find_by_name(name)
    self.find_by_value(:name, name.upcase)
  end

  def self.find_by_short_name(short_name)
    self.find_by_value(:short_name, short_name.downcase)
  end

  # alias old method names for legacy apps
  class << self
    alias_method :find_by_unified, :from_unified
    alias_method :find_by_str, :scan
  end

  protected
  def self.find_by_value(field,value)
    self.all.select { |char| char.send(field).include? value }
  end

end
