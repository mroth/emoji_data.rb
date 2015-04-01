#encoding: UTF-8
require 'spec_helper'

describe EmojiChar do
  describe ".new" do
    before(:all) do
      poop_json = %q/{"name":"PILE OF POO","unified":"1F4A9","variations":[],"docomo":"","au":"E4F5","softbank":"E05A","google":"FE4F4","image":"1f4a9.png","sheet_x":11,"sheet_y":19,"short_name":"hankey","short_names":["hankey","poop","shit"],"text":null}/
      @poop = EmojiChar.new(JSON.parse poop_json)
    end
    it "should create instance getters for all key-values in emoji.json, with blanks as nil" do
      @poop.name.should eq('PILE OF POO')
      @poop.unified.should eq('1F4A9')
      @poop.variations.should eq([])
      @poop.docomo.should eq('')
      @poop.au.should eq('E4F5')
      @poop.softbank.should eq('E05A')
      @poop.google.should eq('FE4F4')
      @poop.image.should eq('1f4a9.png')
      @poop.sheet_x.should eq(11)
      @poop.sheet_y.should eq(19)
      @poop.short_name.should eq('hankey')
      @poop.short_names.should eq(["hankey","poop","shit"])
      @poop.text.should eq(nil)
    end
  end

  context "instance methods" do
    before(:all) do
      @invader   = EmojiChar.new({'unified' => '1F47E'})
      @usflag    = EmojiChar.new({'unified' => '1F1FA-1F1F8'})
      @hourglass = EmojiChar.new({'unified' => '231B', 'variations' => ['231B-FE0F']})
      @cloud     = EmojiChar.new({'unified' => '2601', 'variations' => ['2601-FE0F']})
      @ear       = EmojiChar.new({'unified' => '1F442', 'skin_variations' => { '1F442-1F3FF' => { 'unified' => '1F442-1F3FF' }}})
    end

    describe "#to_s" do
      it "should return the unicode char as string as default to_s" do
        @invader.to_s.should eq(@invader.char)
      end
    end

    describe "#render" do
      it "should render as happy shiny unicode" do
        @invader.render.should eq("👾")
      end
      it "should render as happy shiny unicode for doublebyte chars too" do
        @usflag.render.should eq("🇺🇸")
      end
      it "should have a flag to output forced emoji variant char encoding if requested" do
        @cloud.render(    {variant_encoding: false}).should eq("\u{2601}")
        @cloud.render(    {variant_encoding:  true}).should eq("\u{2601}\u{FE0F}")
        @invader.render(  {variant_encoding: false}).should eq("\u{1F47E}")
        @invader.render(  {variant_encoding:  true}).should eq("\u{1F47E}")
      end
      it "should default to variant encoding for chars with a variant present" do
        @cloud.render.should eq("\u{2601}\u{FE0F}")
        @hourglass.render.should eq("\u{231B}\u{FE0F}")
      end
    end

    describe "#char - DEPRECATED" do
      it "should maintain compatibility with old method name for .render" do
        @cloud.char.should eq(@cloud.render)
      end
    end

    describe "#chars" do
      it "should return an array of all possible string render variations" do
        @invader.chars.should eq(["\u{1F47E}"])
        @cloud.chars.should   eq(["\u{2601}","\u{2601}\u{FE0F}"])
      end
    end

    describe "#doublebyte?" do
      it "should indicate when a character is doublebyte based on the unified ID" do
        @usflag.doublebyte?.should be_true
        @invader.doublebyte?.should be_false
      end
    end

    describe "#variant?" do
      it "should indicate when a character has an alternate variant encoding" do
        @hourglass.variant?.should be_true
        @usflag.variant?.should be_false
      end
    end

    describe "#skin_variant?" do
      it "should indicate when a character has a skin variant encoding" do
        @ear.skin_variant?.should be_true
        @usflag.variant?.should be_false
      end
    end

    describe "#variant" do
      it "should return the most likely variant encoding ID representation for the char" do
        @hourglass.variant.should eq('231B-FE0F')
      end
      it "should return nil if no variant encoding for the char exists" do
        @usflag.variant.should be_nil
      end
    end
  end
end
