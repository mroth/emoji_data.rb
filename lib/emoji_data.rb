require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData

  GEM_ROOT = File.join(File.dirname(__FILE__), '..')
  VENDOR_DATA = 'vendor/emoji-data/emoji.json'

  # precomputed list of all possible emoji characters
  EMOJI_CHARS = begin
    raw_json = IO.read(File.join(GEM_ROOT, VENDOR_DATA))
    vendordata = JSON.parse( raw_json )
    vendordata.map { |em| EmojiChar.new(em) }
  end

  # precomputed hashmap for fast precached lookups
  EMOJICHAR_UNIFIED_MAP = begin
    results = Hash[EMOJI_CHARS.map { |u| [u.unified, u] }]
    EMOJI_CHARS.select(&:variant?).each do |char|
      char.variations.each do |variant|
        results.merge! Hash[variant,char]
      end
    end
    results
  end
  

  # Returns an array of all known EmojiChar.
  def self.all
    EMOJI_CHARS
  end

  # Returns an array of all EmojiChar that are doublebyte encoded.
  def self.all_doublebyte
    EMOJI_CHARS.select(&:doublebyte?)
  end

  # Returns an array of all EmojiChar that have Unicode variant encoding.
  def self.all_with_variants
    EMOJI_CHARS.select(&:variant?)
  end

  # An array of all known emoji chars rendered as UTF-8 strings.
  def self.chars(options={})
    options = {include_variants: false}.merge(options)

    normals = EMOJI_CHARS.map { |c| c.render({variant_encoding: false}) }

    if options[:include_variants]
      extras  = self.all_with_variants.map { |c| c.render({variant_encoding: true}) }
      return normals + extras
    end
    normals
  end

  # An array of all known emoji glyph codepoints.
  def self.codepoints(options={})
    options = {include_variants: false}.merge(options)

    normals = EMOJI_CHARS.map(&:unified)

    if options[:include_variants]
      extras = self.all_with_variants.map {|c| c.variant}
      return normals + extras
    end
    normals
  end

  # Convert a native string glyph to a unified ID.
  #
  # This is a conversion operation, not a match, so it may produce unexpected
  # results with different types of values.
  def self.char_to_unified(char)
    char.codepoints.to_a.map { |i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  # Convert a unified codepoint ID to the UTF-8 string representation.
  #
  # @param [String] uid the unified codepoint ID for an emoji
  # @return [String] UTF-8 string representation of the emoji glyph
  def self.unified_to_char(cp)
    EmojiChar::unified_to_char(cp)
  end

  # Find a specific EmojiChar by its unified ID.
  def self.from_unified(cp)
    EMOJICHAR_UNIFIED_MAP[cp.upcase]
  end

  # Search a string for all EmojiChars contained within.
  #
  # Returns an array of all EmojiChars contained within that string, in order.
  FBS_REGEXP = Regexp.new("(?:#{EmojiData.chars({include_variants: true}).join("|")})")
  def self.scan(str)
    matches = str.scan(FBS_REGEXP)
    matches.map { |m| EmojiData.from_unified(EmojiData.char_to_unified(m)) }
  end

  # Find all EmojiChars that match a contain substring in their official name.
  def self.find_by_name(name)
    self.find_by_value(:name, name.upcase)
  end

  # Find all EmojiChars that match a contain substring in their short name.
  def self.find_by_short_name(short_name)
    self.find_by_value(:short_name, short_name.downcase)
  end

  # TODO: port over .from_shortname from NodeJS version
  # needs to be added to benchmarks for all versions too!

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
