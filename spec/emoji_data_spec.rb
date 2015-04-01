#encoding: UTF-8
require 'spec_helper'

describe EmojiData do
  describe ".all" do
    it "should return an array of all 845 known emoji chars" do
      EmojiData.all.count.should eq(900)
    end
    it "should return all EmojiChar objects" do
      EmojiData.all.all? {|char| char.class == EmojiData::EmojiChar}.should be_true
    end
  end

  describe ".all_doublebyte" do
    it "should return an array of all 21 known emoji chars with doublebyte encoding" do
      EmojiData.all_doublebyte.count.should eq(71)
    end
  end

  describe ".all_with_variants" do
    it "should return an array of all 107 known emoji chars with variant encodings" do
      EmojiData.all_with_variants.count.should eq(116)
    end
  end

  describe ".chars" do
    it "should return an array of all chars in unicode string format" do
      EmojiData.chars.all? {|char| char.class == String}.should be_true
    end
    it "should by default return one entry per known EmojiChar" do
      EmojiData.chars.count.should eq(EmojiData.all.count)
    end
    it "should include variants in list when options {include_variants: true}" do
      results = EmojiData.chars({include_variants: true})
      numChars    = EmojiData.all.count
      numVariants = EmojiData.all_with_variants.count
      results.count.should eq(numChars + numVariants)
    end
    it "should not have any duplicates in list when variants are included" do
      results = EmojiData.chars({include_variants: true})
      results.count.should eq(results.uniq.count)
    end
  end

  describe ".codepoints" do
    it "should return an array of all known codepoints in dashed string representation" do
      EmojiData.codepoints.all? {|cp| cp.class == String}.should be_true
      EmojiData.codepoints.all? {|cp| cp.match(/^[0-9A-F\-]{4,42}$/)}.should be_true
    end
    it "should include variants in list when options {include_variants: true}" do
      results = EmojiData.codepoints({include_variants: true})
      numChars    = EmojiData.all.count
      numVariants = EmojiData.all_with_variants.count
      results.count.should eq(numChars + numVariants)
      results.all? {|cp| cp.match(/^[0-9A-F\-]{4,42}$/)}.should be_true
    end
  end

  describe ".scan" do
    before(:all) do
      @exact_results   = EmojiData.scan("🚀")
      @multi_results   = EmojiData.scan("flying on my 🚀 to visit the 👾 people.")
      @variant_results = EmojiData.scan("\u{0023}\u{FE0F}\u{20E3}")
      @variant_multi   = EmojiData.scan("first a \u{0023}\u{FE0F}\u{20E3} then a 🚀")
    end
    it "should find the proper EmojiChar object from a single string char" do
      @exact_results.should be_kind_of(Array)
      @exact_results.length.should eq(1)
      @exact_results.first.should be_kind_of(EmojiChar)
      @exact_results.first.name.should eq('ROCKET')
    end
    it "should find the proper EmojiChar object from a variant encoded char" do
      @variant_results.length.should eq(1)
      @variant_results.first.name.should eq('HASH KEY')
    end
    it "should match multiple chars from within a string" do
      @multi_results.should be_kind_of(Array)
      @multi_results.length.should eq(2)
      @multi_results[0].should be_kind_of(EmojiChar)
      @multi_results[1].should be_kind_of(EmojiChar)
    end
    it "should return multiple matches in the proper order" do
      @multi_results[0].name.should eq('ROCKET')
      @multi_results[1].name.should eq('ALIEN MONSTER')
    end
    it "should return multiple matches in the proper order for variant encodings" do
      @variant_multi[0].name.should eq('HASH KEY')
      @variant_multi[1].name.should eq('ROCKET')
    end
  end

  describe ".find_by_str - DEPRECATED" do
    it "should maintain compatibility with old method name for .scan" do
      EmojiData.find_by_str("\u{0023}\u{FE0F}\u{20E3}").should eq(EmojiData.scan("\u{0023}\u{FE0F}\u{20E3}"))
    end
  end

  describe ".from_unified" do
    it "should find the proper EmojiChar object" do
      results = EmojiData.from_unified('1f680')
      results.should be_kind_of(EmojiChar)
      results.name.should eq('ROCKET')
    end
    it "should normalise capitalization for hex values" do
      EmojiData.from_unified('1f680').should_not be_nil
    end
    it "should find via variant encoding ID format as well" do
      results = EmojiData.from_unified('2764-fe0f')
      results.should_not be_nil
      results.name.should eq('HEAVY BLACK HEART')
    end
  end

  describe ".find_by_unified - DEPRECATED" do
    it "should maintain compatibility with old method name for .from_unified" do
      EmojiData.find_by_unified('1f680').should eq(EmojiData.from_unified('1f680'))
    end
  end

  describe ".find_by_name" do
    it "returns an array of results, upcasing input if needed" do
      EmojiData.find_by_name('tree').should be_kind_of(Array)
      EmojiData.find_by_name('tree').count.should eq(5)
    end
    it "returns [] if nothing is found" do
      EmojiData.find_by_name('sdlkfjlskdfj').should_not be_nil
      EmojiData.find_by_name('sdlkfjlskdfj').should be_kind_of(Array)
      EmojiData.find_by_name('sdlkfjlskdfj').count.should eq(0)
    end
  end

  describe ".find_by_short_name" do
    it "returns an array of results, downcasing input if needed" do
      EmojiData.find_by_short_name('MOON').should be_kind_of(Array)
      EmojiData.find_by_short_name('MOON').count.should eq(13)
    end
    it "returns [] if nothing is found" do
      EmojiData.find_by_short_name('sdlkfjlskdfj').should_not be_nil
      EmojiData.find_by_short_name('sdlkfjlskdfj').should be_kind_of(Array)
      EmojiData.find_by_short_name('sdlkfjlskdfj').count.should eq(0)
    end
  end

  describe ".from_short_name" do
    it "returns exact matches on a short name" do
      results = EmojiData.from_short_name('scream')
      results.should be_kind_of(EmojiChar)
      results.name.should eq('FACE SCREAMING IN FEAR')
    end
    it "handles lowercasing input if required" do
      EmojiData.from_short_name('SCREAM').should eq( EmojiData.from_short_name('scream') )
    end
    it "works on secondary keywords" do
      primary = EmojiData.from_short_name('hankey')
      EmojiData.from_short_name('poop').should eq(primary)
      EmojiData.from_short_name('shit').should eq(primary)
    end
    it "returns nil if nothing matches" do
      EmojiData.from_short_name('taco').should be_nil
    end
  end

  describe ".char_to_unified" do
    it "converts normal emoji to unified codepoint" do
      EmojiData.char_to_unified("👾").should eq('1F47E')
      EmojiData.char_to_unified("🚀").should eq('1F680')
    end
    it "converts double-byte emoji to proper codepoint" do
      EmojiData.char_to_unified("🇺🇸").should eq('1F1FA-1F1F8')
      EmojiData.char_to_unified("#⃣").should eq('0023-20E3')
    end
    it "converts variant encoded emoji to variant unified codepoint" do
      EmojiData.char_to_unified("\u{2601}\u{FE0F}").should eq('2601-FE0F')
    end
  end

  # TODO: below is kinda redundant but it is helpful as a helper method so maybe still test
  describe ".unified_to_char" do
    it "converts normal unified codepoints to unicode strings" do
      EmojiData.unified_to_char('1F47E').should eq("👾")
      EmojiData.unified_to_char('1F680').should eq("🚀")
    end
    it "converts doublebyte unified codepoints to unicode strings" do
      EmojiData.unified_to_char('1F1FA-1F1F8').should eq("🇺🇸")
      EmojiData.unified_to_char('0023-20E3').should eq("#⃣")
    end
    it "converts variant unified codepoints to unicode strings" do
      EmojiData.unified_to_char('2764-fe0f').should eq("\u{2764}\u{FE0F}")
    end
    it "converts variant+doublebyte chars (triplets!) to unicode strings" do
      EmojiData.unified_to_char('0030-FE0F-20E3').should eq("\u{0030}\u{FE0F}\u{20E3}")
    end
  end
end
