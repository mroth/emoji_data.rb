require 'spec_helper'

describe EmojiChar do
  describe ".new" do
    before(:all) do
      poop_json = %q/{"name":"PILE OF POO","unified":"1F4A9","docomo":"","au":"E4F5","softbank":"E05A","google":"FE4F4","image":"1f4a9.png","sheet_x":13,"sheet_y":19,"short_name":"hankey","short_names":["hankey","poop","shit"],"text":null}/
      @poop = EmojiChar.new(JSON.parse poop_json)
    end
    it "should create instance getters for all key-values in emoji.json, with blanks as nil" do
      @poop.name.should eq('PILE OF POO')
      @poop.unified.should eq('1F4A9')
      @poop.docomo.should eq('')
      @poop.au.should eq('E4F5')
      @poop.softbank.should eq('E05A')
      @poop.google.should eq('FE4F4')
      @poop.image.should eq('1f4a9.png')
      @poop.sheet_x.should eq(13)
      @poop.sheet_y.should eq(19)
      @poop.short_name.should eq('hankey')
      @poop.short_names.should eq(["hankey","poop","shit"])
      @poop.text.should eq(nil)
    end

  end
end