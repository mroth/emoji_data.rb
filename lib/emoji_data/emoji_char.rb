module EmojiData

  class EmojiChar
    def initialize(emoji_hash)
      # http://stackoverflow.com/questions/1615190/declaring-instance-variables-iterating-over-a-hash
      emoji_hash.each do |k,v|
        instance_variable_set("@#{k}",v)
        eigenclass = class<<self; self; end
        eigenclass.class_eval { attr_reader k }
      end
    end

    # Public: Returns a version of the character for rendering to screen.
    def char(options = {})
      options = {variant_encoding: false}.merge(options)
      #decide whether to use the normal unified ID or the variant for encoding to str
      target = (self.variant? && options[:variant_encoding]) ? self.variant : @unified
      target.split('-').map { |i| i.hex }.pack("U*")
    end

    # Public: Is the character represented by a doublebyte unicode codepoint in unicode?
    def doublebyte?
      @unified.match(/-/)
    end

    # does the emojichar have an alternate variant encoding?
    def variant?
      return false if @variations.nil?
      @variations.length > 0
    end

    # return whatever is the most likely variant ID for the emojichar
    # for now, there can only be one, so just return first.
    # (in the future, there may be multiple variants, who knows!)
    def variant
      return nil if @variations.nil?
      @variations.first
    end

    alias_method :to_s, :char
  end

end
