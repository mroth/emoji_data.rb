# emoji_data.rb

[![Gem Version](http://img.shields.io/gem/v/emoji_data.svg?style=flat)](https://rubygems.org/gems/emoji_data)
[![Build Status](http://img.shields.io/travis/mroth/emoji_data.rb.svg?style=flat)](https://travis-ci.org/mroth/emoji_data.rb)
[![Dependency Status](http://img.shields.io/gemnasium/mroth/emoji_data.rb.svg?style=flat)](https://gemnasium.com/mroth/emoji_data.rb)
[![Coverage Status](http://img.shields.io/coveralls/mroth/emoji_data.rb.svg?style=flat)](https://coveralls.io/r/mroth/emoji_data.rb)

Ruby library providing low level operations for dealing with Emoji
glyphs in the Unicode standard. :cool:

EmojiData is like a swiss-army knife for dealing with Emoji encoding issues. If
all you need to do is translate `:poop:` into :poop:, then there are plenty of
other libs out there that will probably do what you want.  But once you are
dealing with Emoji as a fundamental part of your application, and you start to
realize the nightmare of [doublebyte encoding][doublebyte] or
[variants][variant], then this library may be your new best friend.
:raised_hands:

EmojiData is used in production by [Emojitracker.com][emojitracker] to parse
well over 100M+ emoji glyphs daily. :dizzy:

Don't like Ruby? This library has also now been ported to [NodeJS][node] and [Elixir][ex].

[doublebyte]: http://www.quora.com/Why-does-using-emoji-reduce-my-SMS-character-limit-to-70
[variant]: http://www.unicode.org/L2/L2011/11438-emoji-var.pdf
[emojitracker]: http://www.emojitracker.com
[node]: https://github.com/mroth/emoji-data-js
[ex]: https://github.com/mroth/exmoji

## Installation

Add this line to your application's `Gemfile`:

    gem 'emoji_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emoji_data

Currently requires `RUBY_VERSION >= 1.9.3`.

## Usage

### Documentation
Full API documentation is available via YARD or here:
http://rubydoc.info/github/mroth/emoji_data.rb/master/frames

### Examples
Here are some examples of the type of stuff you can do:

```irb
>> require 'emoji_data'
=> true

>> EmojiData.from_unified('1f680')
=> #<EmojiData::EmojiChar:0x007f8fdba33b40 @variations=[], @name="ROCKET",
@unified="1F680", @docomo=nil, @au="E5C8", @softbank="E10D", @google="FE7ED",
@image="1f680.png", @sheet_x=25, @sheet_y=4, @short_name="rocket",
@short_names=["rocket"], @text=nil, @apple_img=true, @hangouts_img=true,
@twitter_img=true>

>> EmojiData.all.count
=> 845

>> EmojiData.all_with_variants.count
=> 107

>> EmojiData.find_by_short_name("moon").count
=> 13

>> EmojiData.all.select(&:doublebyte?).map(&:short_name)
=> ["hash", "zero", "one", "two", "three", "four", "five", "six", "seven",
"eight", "nine", "cn", "de", "es", "fr", "gb", "it", "jp", "kr", "ru", "us"]

>> EmojiData.find_by_name("tree").map { |c| [c.unified, c.name, c.render] }
=> [["1F332", "EVERGREEN TREE", "🌲"], ["1F333", "DECIDUOUS TREE", "🌳"],
["1F334", "PALM TREE", "🌴"], ["1F384", "CHRISTMAS TREE", "🎄"], ["1F38B",
"TANABATA TREE", "🎋"]]

>> EmojiData.scan("I ♥ when marketers talk about the ☁. #blessed").each do |ec|
?>   puts "Found some #{ec.short_name}!"
>> end
Found some hearts!
Found some cloud!
=> [...]
```

## Contributing

Please be sure to run `rake spec` and help keep test coverage at :100:.

There is a full benchmark suite available via `scripts/benchmark.rb`.  Please
run before and after your changes to ensure you have not caused a performance
regression.

## License

[The MIT License (MIT)](LICENSE)
