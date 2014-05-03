# Changelog

## 0.1.0 (3 May 2014)

 * Add support for Unicode variant encodings, used by MacOSX 10.9 / iOS 7.
   - For more info: http://www.unicode.org/L2/L2011/11438-emoji-var.pdf
   - By default, `EmojiChar.to_s()` and `.char()` will now use the variant encoding.
 * With adding support for variants, the speed of `find_by_str` regressed by approximately 20% (because there are more codepoints to match against). To counter this, we switched to a Regex based scan than improves performance of the method by over 250x(!).  A complete sorted search against 1000 strings now takes ~2ms where before it would take around a half second.
 * Import latest version of iamcal/emoji-data.
 * 100% test coverage. :sunglasses:

## 0.0.3 (1 April 2014)

 * On initialization, create hashmaps to cache lookups for `.find_by_unified()`.

   In a quick benchmark in MRI 2.1.1, this reduces the time needed for one million lookups from `13.5s` to `0.3s`!

   This is only for lookup by unified ID for now, since the other `find_by_*()` methods are actually searches that can return multiple values.  I'll look at nested hashmaps for those if there is a pressing performance need later.

## 0.0.2 (3 December 2013)

 * Remove JSON gem dependency since no longer supporting Ruby 1.8.7 anyhow.
 * Add `EmojiData.find_by_str` convenience method to match on a string.
 * Make default `EmojiChar.to_s()` the same as `EmojiChar.char()`


## 0.0.1 (7 June 2013)

 * Initial release
