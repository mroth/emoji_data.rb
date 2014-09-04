require 'emoji_data/version'
require 'emoji_data/emoji_char'
require 'json'

module EmojiData

  # specify some location paths
  GEM_ROOT = File.join(File.dirname(__FILE__), '..')
  VENDOR_DATA = 'vendor/emoji-data/emoji.json'

  # precomputed list of all possible emoji characters
  EMOJI_CHARS = begin
    raw_json = IO.read(File.join(GEM_ROOT, VENDOR_DATA))
    vendordata = JSON.parse( raw_json )
    vendordata.map { |em| EmojiChar.new(em) }
  end

  # precomputed hashmap for fast precached lookups in .from_unified
  EMOJICHAR_UNIFIED_MAP = {}
  EMOJI_CHARS.each do |ec|
    EMOJICHAR_UNIFIED_MAP[ec.unified] = ec
    ec.variations.each  { |variant| EMOJICHAR_UNIFIED_MAP[variant] = ec }
  end

  # precomputed hashmap for fast precached lookups in .from_short_name
  EMOJICHAR_KEYWORD_MAP = {}
  EMOJI_CHARS.each do |ec|
    ec.short_names.each { |keyword| EMOJICHAR_KEYWORD_MAP[keyword] = ec }
  end

  # our constants are only for usage internally
  private_constant :GEM_ROOT, :VENDOR_DATA
  private_constant :EMOJI_CHARS, :EMOJICHAR_UNIFIED_MAP, :EMOJICHAR_KEYWORD_MAP


  # Returns a list of all known Emoji characters as `EmojiChar` objects.
  #
  # @return [Array<EmojiChar>] a list of all known `EmojiChar`.
  def self.all
    EMOJI_CHARS
  end

  # Returns a list of all `EmojiChar` that are represented with doublebyte
  # encoding.
  #
  # @return [Array<EmojiChar>] a list of all doublebyte `EmojiChar`.
  def self.all_doublebyte
    EMOJI_CHARS.select(&:doublebyte?)
  end

  # Returns a list of all `EmojiChar` that have at least one variant encoding.
  #
  # @return [Array<EmojiChar>] a list of all `EmojiChar` with variant encoding.
  def self.all_with_variants
    EMOJI_CHARS.select(&:variant?)
  end

  # Returns a list of all known Emoji characters rendered as UTF-8 strings.
  #
  # By default, the default rendering options for this library will be used.
  # However, if you pass an option hash with `include_variants: true` then all
  # possible renderings of a single glyph will be included, meaning that:
  #
  # 1. You will have "duplicate" emojis in your list.
  # 2. This list is now suitable for exhaustably matching against in a search.
  #
  # @option opts [Boolean] :include_variants whether or not to include all
  #   possible encoding variants in the list
  #
  # @return [Array<String>] all Emoji characters rendered as UTF-8 strings
  def self.chars(opts={})
    options = {include_variants: false}.merge(opts)

    normals = EMOJI_CHARS.map { |c| c.render({variant_encoding: false}) }

    if options[:include_variants]
      extras  = self.all_with_variants.map { |c| c.render({variant_encoding: true}) }
      return normals + extras
    end
    normals
  end

  # Returns a list of all known codepoints representing Emoji characters.
  #
  # @option (see .chars)
  # @return [Array<String>] all codepoints represented as unified ID strings
  def self.codepoints(opts={})
    options = {include_variants: false}.merge(opts)

    normals = EMOJI_CHARS.map(&:unified)

    if options[:include_variants]
      extras = self.all_with_variants.map {|c| c.variant}
      return normals + extras
    end
    normals
  end

  # Convert a native UTF-8 string glyph to its unified codepoint ID.
  #
  # This is a conversion operation, not a match, so it may produce unexpected
  # results with different types of values.
  #
  # @param char [String] a single rendered emoji glyph encoded as a UTF-8 string
  # @return [String] the unified ID
  #
  # @example
  #   >> EmojiData.unified_to_char("1F47E")
  #   => "👾"
  def self.char_to_unified(char)
    char.codepoints.to_a.map { |i| i.to_s(16).rjust(4,'0')}.join('-').upcase
  end

  # Convert a unified codepoint ID directly to its UTF-8 string representation.
  #
  # @param uid [String] the unified codepoint ID for an emoji
  # @return [String] UTF-8 string rendering of the emoji character
  #
  # @example
  #   >> EmojiData.char_to_unified("👾")
  #   => "1F47E"
  def self.unified_to_char(uid)
    EmojiChar::unified_to_char(uid)
  end

  # Finds a specific `EmojiChar` based on its unified codepoint ID.
  #
  # @param uid [String] the unified codepoint ID for an emoji
  # @return [EmojiChar]
  def self.from_unified(uid)
    EMOJICHAR_UNIFIED_MAP[uid.upcase]
  end

  # precompile regex pattern for fast matches in `.scan`
  # needs to be defined after self.chars so not at top of file for now...
  FBS_REGEXP = Regexp.new(
    "(?:#{EmojiData.chars({include_variants: true}).join("|")})"
  )
  private_constant :FBS_REGEXP

  # Scans a string for all encoded emoji characters contained within.
  #
  # @param str [String] the target string to search
  # @return [Array<EmojiChar>] all emoji characters contained within the target
  #    string, in the order they appeared.
  #
  # @example
  #   >> EmojiData.scan("flying on my 🚀 to visit the 👾 people.")
  #   => [#<EmojiData::EmojiChar... @name="ROCKET", @unified="1F680", ...>,
  #   #<EmojiData::EmojiChar... @name="ALIEN MONSTER", @unified="1F47E", ...>]
  def self.scan(str)
    matches = str.scan(FBS_REGEXP)
    matches.map { |m| EmojiData.from_unified(EmojiData.char_to_unified(m)) }
  end

  # Finds any `EmojiChar` that contains given string in its official name.
  #
  # @param name [String]
  # @return [Array<EmojiChar>]
  def self.find_by_name(name)
    self.find_by_value(:name, name.upcase)
  end

  # Find all `EmojiChar` that match string in any of their associated short
  # name keywords.
  #
  # @param short_name [String]
  # @return [Array<EmojiChar>]
  def self.find_by_short_name(short_name)
    self.find_by_value(:short_name, short_name.downcase)
  end

  # Finds a specific `EmojiChar` based on the unified codepoint ID.
  #
  # Must be exact match.
  #
  # @param short_name [String]
  # @return [EmojiChar]
  def self.from_short_name(short_name)
    EMOJICHAR_KEYWORD_MAP[short_name.downcase]
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
