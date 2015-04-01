module EmojiData

  # EmojiChar represents a single Emoji character and its associated metadata.
  #
  # @!attribute name
  #   @return [String] The standardized name used in the Unicode specification
  #     to represent this emoji character.
  #
  # @!attribute unified
  #   @return [String] The primary unified codepoint ID for the emoji character.
  #
  # @!attribute variations
  #   @return [Array<String>] A list of all variant codepoints that may also
  #     represent this emoji.
  #
  # @!attribute short_name
  #   @return [String] The canonical "short name" or keyword used in many
  #     systems to refer to this emoji. Often surrounded by `:colons:` in
  #     systems like GitHub & Campfire.
  #
  # @!attribute short_names
  #   @return [Array<String>] A full list of possible keywords for the emoji.
  #
  # @!attribute text
  #   @return [String] An alternate textual representation of the emoji, for
  #   example a smiley face emoji may be represented with an ASCII alternative.
  #   Most emoji do not have a text alternative. This is typically used when
  #   building an automatic translation from typed emoticons.
  #
  class EmojiChar

    def initialize(emoji_hash)
      # work around inconsistency in emoji.json for now by just setting a blank
      # array for instance value, and let it get overriden in main
      # deserialization loop if variable is present.
      @variations = []
      @skin_variations = []

      # trick for declaring instance variables while iterating over a hash
      # http://stackoverflow.com/questions/1615190/
      emoji_hash.each do |k,v|
        if v.kind_of?(Hash)
          v = v.map do |_, variation|
            EmojiChar.new(variation)
          end
        end
        instance_variable_set("@#{k}",v)
        eigenclass = class<<self; self; end
        eigenclass.class_eval { attr_reader k }
      end
    end

    attr_reader :skin_variations

    # Renders an `EmojiChar` to its string glyph representation, suitable for
    # printing to screen.
    #
    # @option opts [Boolean] :variant_encoding specify whether the variant
    #   encoding selector should be used to hint to rendering devices that
    #   "graphic" representation should be used. By default, we use this for all
    #   Emoji characters that contain a possible variant.
    #
    # @return [String] the emoji character rendered to a UTF-8 string
    def render(opts = {})
      options = {variant_encoding: true}.merge(opts)
      #decide whether to use the normal unified ID or the variant for encoding to str
      target = (self.variant? && options[:variant_encoding]) ? self.variant : @unified
      EmojiChar::unified_to_char(target)
    end

    alias_method :to_s, :render
    alias_method :char, :render

    # Returns a list of all possible UTF-8 string renderings of an `EmojiChar`.
    #
    # E.g., normal, with variant selectors, etc. This is useful if you want to
    # have all possible values to match against when searching for the emoji in
    # a string representation.
    #
    # @return [Array<String>] all possible UTF-8 string renderings
    def chars
      results = [self.render({variant_encoding: false})]
      @variations.each do |variation|
        results << EmojiChar::unified_to_char(variation)
      end
      @skin_variations.each do |skin_variation|
        results += skin_variation.chars
      end
      @chars ||= results
    end

    # Is the `EmojiChar` represented by a doublebyte codepoint in Unicode?
    #
    # @return [Boolean]
    def doublebyte?
      @unified.include? "-"
    end

    # Does the `EmojiChar` have an alternate Unicode variant encoding?
    #
    # @return [Boolean]
    def variant?
      @variations.length > 0
    end

    # Does the `EmojiChar` have an alternate skin variant encoding?
    #
    # @return [Boolean]
    def skin_variant?
      @skin_variations.length > 0
    end

    # Returns the most likely variant-encoding codepoint ID for an `EmojiChar`.
    #
    # For now we only know of one possible variant encoding for certain
    # characters, but there could be others in the future.
    #
    # This is typically used to force Emoji rendering for characters that could
    # be represented in standard font glyphs on certain operating systems.
    #
    # The resulting encoded string will be two codepoints, or three codepoints
    # for doublebyte Emoji characters.
    #
    # @return [String, nil]
    #   The most likely variant-encoding codepoint ID.
    #   If there is no variant-encoding for a character, returns nil.
    def variant
      @variations.first
    end


    protected

    def self.unified_to_char(cps)
      cps.split('-').map { |i| i.hex }.pack("U*")
    end

  end
end
