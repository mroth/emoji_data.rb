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

[doublebyte]: http://www.quora.com/Why-does-using-emoji-reduce-my-SMS-character-limit-to-70
[variant]: http://www.unicode.org/L2/L2011/11438-emoji-var.pdf
[emojitracker]: http://www.emojitracker.com

## Installation

Add this line to your application's `Gemfile`:

    gem 'emoji_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emoji_data

Currently requires `RUBY_VERSION >= 1.9.3`.

## Example Usage

Full API documentation is available via YARD or here:
http://rubydoc.info/github/mroth/emoji_data.rb/master/frames

Pretty straightforward, read the source.  But here are some things you might
care about:

### EmojiData

  The `EmojiData` module provides some convenience methods for dealing with the
  library of known emoji characters.  Check out the source to see what's up.

Some notable methods to call out:

`EmojiData.from_unified(id)` gives you a quick way to grab a specific `EmojiChar`.

```irb
>> EmojiData.from_unified('1f680')
=> #<EmojiData::EmojiChar:0x007f8fdba33b40 @variations=[], @name="ROCKET",
@unified="1F680", @docomo=nil, @au="E5C8", @softbank="E10D", @google="FE7ED",
@image="1f680.png", @sheet_x=25, @sheet_y=4, @short_name="rocket",
@short_names=["rocket"], @text=nil, @apple_img=true, @hangouts_img=true,
@twitter_img=true>
```

`EmojiData.find_by_name(name)` and `.find_by_short_name(name)` do pretty much
what you'd expect:

```irb
>> EmojiData.find_by_name('thumb')
=> [#<EmojiData::EmojiChar:0x007f8fdb939780 @variations=[], @name="THUMBS UP
SIGN", @unified="1F44D", @docomo="E727", @au="E4F9", @softbank="E00E",
@google="FEB97", @image="1f44d.png", @sheet_x=13, @sheet_y=22, @short_name="+1",
@short_names=["+1", "thumbsup"], @text=nil, @apple_img=true, @hangouts_img=true,
@twitter_img=true>, #<EmojiData::EmojiChar:0x007f8fdb933510 @variations=[],
@name="THUMBS DOWN SIGN", @unified="1F44E", @docomo="E700", @au="EAD5",
@softbank="E421", @google="FEBA0", @image="1f44e.png", @sheet_x=13, @sheet_y=23,
@short_name="-1", @short_names=["-1", "thumbsdown"], @text=nil, @apple_img=true,
@hangouts_img=true, @twitter_img=true>]
```

`EmojiData.char_to_unified(char)` takes a string containing a unified unicode
representation of an emoji character and gives you the unicode ID.

```irb
>> EmojiData.char_to_unified('🚀')
=> "1F680"
```

 `EmojiData.all` will return an array of all known EmojiChars, so you can map
 or do whatever funky Enumerable stuff you want to do across the entire
 character set.

```irb
#gimmie the shortname of all doublebyte chars
>> EmojiData.all.select(&:doublebyte?).map(&:short_name)
=> ["hash", "zero", "one", "two", "three", "four", "five", "six", "seven",
"eight", "nine", "cn", "de", "es", "fr", "gb", "it", "jp", "kr", "ru", "us"]
```

### EmojiData::EmojiChar

`EmojiData::EmojiChar` is a class representing a single emoji character.  All
the variables from the `iamcal/emoji-data` dataset have dynamically generated
getter methods.

There are some additional convenience methods, such as `#doublebyte?` etc. Most
important addition is the `#render` method which will output a properly unicode
encoded string containing the character.

## License

[The MIT License (MIT)](LICENSE)
