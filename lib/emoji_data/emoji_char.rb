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

    def to_char
      @char ||= @unified.split('-').map { |i| i.hex }.pack("U*")
    end

    def doublebyte?
      @unified.match(/-/)
    end
  end

end
