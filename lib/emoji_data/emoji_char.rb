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
    def char
      @char ||= @unified.split('-').map { |i| i.hex }.pack("U*")
    end

    # Public: Is the character represented by a doublebyte unicode codepoint in unicode?
    def doublebyte?
      @unified.match(/-/)
    end

    alias_method :to_s, :char
  end

end
