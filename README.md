# emoji_data.rb

Provides classes and methods for dealing with emoji character data as unicode.

Note, this is more useful for low-level operations.  If you can avoid having to deal with unicode character data extensively and just want to encode/decode stuff, [rumoji](https://github.com/mwunsch/rumoji) is probably a better bet for you.

This library currently considers `iamcal/emoji-data` to be the "source of truth" regarding certain things, such as how to represent doublebyte unified codepoints as strings.

This is basically a helper library for [emojitrack](https://github.com/mroth/emojitrack) and [emojistatic](https://github.com/mroth/emojistatic), but may be useful for other people.

## Installation

Add this line to your application's Gemfile:

    gem 'emoji_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emoji_data

## Usage

Things you might care about:

  `EmojiData::EmojiChar`: is a class representing a single emoji character.  All the variables from `emoji-data` have dynamically generated getter methods.  There are some additional convenience methods, such as `#doublebyte?` etc. Most important addition is the `#char` method which will output a properly unicode encoded string containing the character.

  The `EmojiData` module itself has some convenience methods.  Check out the source to see what's up. Probably most useful is `.chars` which gives you an array of all known EmojiChars, so you can map or do whatever funky Enumerable stuff you need to do across the entire character set.
