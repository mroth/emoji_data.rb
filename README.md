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

TODO: Write usage instructions here

