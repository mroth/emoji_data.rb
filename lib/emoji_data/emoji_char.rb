module EmojiData

  class EmojiChar
    attr_reader :name, :unified, :short_name

    def initialize(emoji_hash)
      @name       = emoji_hash['name']
      @unified    = emoji_hash['unified']
      @docomo     = emoji_hash['docomo']
      @au         = emoji_hash['au']
      @softbank   = emoji_hash['softbank']
      @google     = emoji_hash['google']
      @image      = emoji_hash['image']
      @sheet_x    = emoji_hash['sheet_x']
      @sheet_y    = emoji_hash['sheet_y']
      @short_name = emoji_hash['short_name']
      @text       = emoji_hash['text']
    end

    def to_char
      @char ||= @unified.split('-').map { |i| i.hex }.pack("U*")
    end

    def doublebyte?
      @unified.match(/-/)
    end
  end

end
