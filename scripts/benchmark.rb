# encoding: UTF-8

require './lib/emoji_data'
require 'benchmark/ips'

suites = []

s0 = "I liek to eat cake oh so very much cake eating is nice!! #cake #food"
s1 = "🚀"
s2 = "flying on my 🚀 to visit the 👾 people."
s3 = "first a \u{0023}\u{FE0F}\u{20E3} then a 🚀"

suites << Benchmark.ips do |x|
  x.config(:time => 1, :warmup => 0)
  x.report("EmojiData.scan(s0)") { EmojiData.scan(s0) }
  x.report("EmojiData.scan(s1)") { EmojiData.scan(s1) }
  x.report("EmojiData.scan(s2)") { EmojiData.scan(s2) }
  x.report("EmojiData.scan(s3)") { EmojiData.scan(s3) }
end


suites << Benchmark.ips do |x|
  x.config(:time => 1, :warmup => 0)
  x.report("EmojiData.all")                       { EmojiData.all() }
  x.report("EmojiData.all_doublebyte")            { EmojiData.all_doublebyte() }
  x.report("EmojiData.all_with_variants")         { EmojiData.all_with_variants() }
  x.report("EmojiData.from_unified")              { EmojiData.from_unified("1F680") }
  x.report("EmojiData.chars")                     { EmojiData.chars() }
  x.report("EmojiData.codepoints")                { EmojiData.codepoints() }
  x.report("EmojiData.find_by_name - many")       { EmojiData.find_by_name("tree") }
  x.report("EmojiData.find_by_name - none")       { EmojiData.find_by_name("zzzz") }
  x.report("EmojiData.find_by_short_name - many") { EmojiData.find_by_short_name("MOON") }
  x.report("EmojiData.find_by_short_name - none") { EmojiData.find_by_short_name("zzzz") }
  x.report("EmojiData.char_to_unified - single")  { EmojiData.char_to_unified("🚀") }
  x.report("EmojiData.char_to_unified - double")  { EmojiData.char_to_unified("\u{2601}\u{FE0F}") }
  x.report("EmojiData.unified_to_char - single")  { EmojiData.unified_to_char("1F47E") }
  x.report("EmojiData.unified_to_char - double")  { EmojiData.unified_to_char("2764-fe0f") }
  x.report("EmojiData.unified_to_char - triple")  { EmojiData.unified_to_char("0030-FE0F-20E3") }
end


invader   = EmojiData::EmojiChar.new({unified: '1F47E'})
usflag    = EmojiData::EmojiChar.new({unified: '1F1FA-1F1F8'})
hourglass = EmojiData::EmojiChar.new({unified: '231B', variations: ['231B-FE0F']})
cloud     = EmojiData::EmojiChar.new({unified: '2601', variations: ['2601-FE0F']})

suites << Benchmark.ips do |x|
  x.config(:time => 1, :warmup => 0)
  x.report("EmojiChar.render - single")  { invader.render() }
  x.report("EmojiChar.render - double")  { usflag.render() }
  x.report("EmojiChar.render - variant") { cloud.render({variant_encoding: true}) }
  x.report("EmojiChar.chars")            { cloud.chars() }
  x.report("EmojiChar.doublebyte?")      { invader.doublebyte?() }
  x.report("EmojiChar.variant?")         { invader.variant?() }
  x.report("EmojiChar.variant")          { invader.variant() }
end


def micros(hz)
  1_000_000 / hz
end

suites.each do |report|
  results = report.entries.sort { |a,b| b.ips <=> a.ips }

  print "\n"
  results.each do |r|
    printf "%-45s %10u   %.2f µs/op\n", r.label, r.iterations, micros(r.ips)
  end
end
