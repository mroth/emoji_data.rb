require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData
  GEM_ROOT = File.join(File.dirname(__FILE__), '..')
  RAW_JSON = IO.read(File.join(GEM_ROOT, 'vendor/emoji-data/emoji.json'))
  EMOJI_MAP = JSON.parse( RAW_JSON )
  EMOJI_CHARS = EMOJI_MAP.map { |em| EmojiChar.new(em) }

  #
  # construct hashmap for fast precached lookups for `.find_by_unified`
  #
  EMOJICHAR_UNIFIED_MAP = Hash[EMOJI_CHARS.map { |u| [u.unified, u] }]
  # merge variant encodings into map so we can look them up as well
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

    if options[:include_variants]
      return EMOJI_CHARS.map(&:char) + self.all_with_variants.map {|c| c.char({variant_encoding: true})}
    end
    EMOJI_CHARS.map(&:char)
  end

  def self.codepoints(options={})
    options = {include_variants: false}.merge(options)

    if options[:include_variants]
      return EMOJI_CHARS.map(&:unified) + self.all_with_variants.map {|c| c.variant}
    end
    EMOJI_CHARS.map(&:unified)
  end

  def self.char_to_unified(char)
    char.codepoints.to_a.map {|i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  def self.unified_to_char(cp)
    EmojiChar::unified_to_char(cp)
  end

  def self.find_by_unified(cp)
    # EMOJI_CHARS.detect { |ec| ec.unified == cp.upcase }
    EMOJICHAR_UNIFIED_MAP[cp.upcase]
  end

  def self.find_by_str(str)
    str.extend EmojiData::StringUtils

    matches = EMOJI_CHARS.select { |ec| str.include_any? ec.chars }
    matches.sort_by { |mc| str.index_first(mc.chars) }
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

  module StringUtils
    def include_any?(charstr)
      charstr.any? { |char| self.include? char }
    end

    def index_first(charstr)
      charstr.each do |char|
        return self.index(char) if !self.index(char).nil?
      end
      nil
    end
  end

end
