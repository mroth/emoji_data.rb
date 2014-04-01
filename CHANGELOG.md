# Changelog

## 0.0.3 (1 April 2013)

 * On initialization, create hashmaps to cache lookups for `.find_by_unified()`.

   In a quick benchmark in MRI 2.1.1, this reduces the time needed for one million lookups from `13.5s` to `0.3s`!

   This is only for lookup by unified ID for now, since the other `find_by_*()` methods are actually searches that can return multiple values.  I'll look at nested hashmaps for those if there is a pressing performance need later.

## 0.0.2 (3 December 2013)

 * Remove JSON gem dependency since no longer supporting Ruby 1.8.7 anyhow.
 * Add `EmojiData.find_by_str` convenience method to match on a string.
 * Make default `EmojiChar.to_s()` the same as `EmojiChar.char()`


## 0.0.1 (7 June 2013)

 * Initial release
