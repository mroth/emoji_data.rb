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
      @invader = EmojiChar.new({'unified' => '1F47E'})
      @usflag = EmojiChar.new({'unified' => '1F1FA-1F1F8'})
    end

    describe "#to_s" do
      it "should return the unicode char as string as default to_s" do
        @invader.to_s.should eq(@invader.char)
      end
    end

    describe "#char" do
      it "should render as happy shiny unicode" do
        @invader.char.should eq("👾")
      end
      it "should render as happy shiny unicode for doublebyte chars too" do
        @usflag.char.should eq("🇺🇸")
      end
      it "should have a flag to output forced emoji variant char encoding if requested"
      it "should default to PENDING encoding for chars with a variant present"
    end

    describe "#doublebyte?" do
      it "should indicate when a character is doublebyte based on the unified ID" do
        @usflag.doublebyte?.should be_true
        @invader.doublebyte?.should be_false
      end
    end

    describe "#variant?" do
      it "should indicate when a character has an alternate variant encoding"
    end

    describe "#variant" do
      it "should return the most likely variant encoding for the char"
      it "should return null if no variant encoding for the char exists"
    end
  end
end
