module EmojiData

  class EmojiChar
    def initialize(emoji_hash)
      # work around inconsistency in emoji.json for now by just setting a blank
      # array for instance value, and let it get overriden in main
      # deserialization loop if variable is present.
      @variations = []

      # http://stackoverflow.com/questions/1615190/declaring-instance-variables-iterating-over-a-hash
      emoji_hash.each do |k,v|
        instance_variable_set("@#{k}",v)
        eigenclass = class<<self; self; end
        eigenclass.class_eval { attr_reader k }
      end
    end

    # Returns a version of the character for rendering to screen.
    #
    # By default this will now use the variant encoding if it exists.
    def render(options = {})
      options = {variant_encoding: true}.merge(options)
      #decide whether to use the normal unified ID or the variant for encoding to str
      target = (self.variant? && options[:variant_encoding]) ? self.variant : @unified
      EmojiChar::unified_to_char(target)
    end

    alias_method :to_s, :render
    alias_method :char, :render

    # Return ALL known possible string encodings of the emoji char.
    #
    # Mostly useful for doing find operations when you need them all.
    def chars
      results = [self.render({variant_encoding: false})]
      @variations.each do |variation|
        results << EmojiChar::unified_to_char(variation)
      end
      @chars ||= results
    end

    # Public: Is the character represented by a doublebyte unicode codepoint in unicode?
    def doublebyte?
      @unified.match(/-/)
    end

    # does the emojichar have an alternate variant encoding?
    def variant?
      @variations.length > 0
    end

    # return whatever is the most likely variant ID for the emojichar
    # for now, there can only be one, so just return first.
    # (in the future, there may be multiple variants, who knows!)
    def variant
      @variations.first
    end


    protected
    def self.unified_to_char(cps)
      cps.split('-').map { |i| i.hex }.pack("U*")
    end

  end

end
