require 'spec_helper'

describe HashParser do
  describe "hash_parser" do
    it "converts a one level hash into an object with attributes" do
      obj = HashParser.new({:foo => "bar"})

      obj.foo.should == "bar"
    end

    it "converts a two level hash into an object with nested attributes" do
      obj = HashParser.new({:foo => {:bar => "Excellent!"}})

      obj.foo.bar.should == "Excellent!"
    end

    it "converts a three level hash into an object with nested attributes" do
      obj = HashParser.new({:foo => {:bar => {:excellent => "YES!"}}})

      obj.foo.bar.excellent == "YES!"
    end

    it "keeps array attributes intact" do
      obj = HashParser.new({:foo => ["bar", "bar", "brack", "shreep"]})

      obj.foo.count.should == 4
    end

    it "keeps non-string values intact" do
      obj = HashParser.new(:my_hash => {:my_int => 5, :my_float => 1.234, :my_date => Date.parse("25/12/2012")})

      obj.my_hash.my_int.should == 5
      obj.my_hash.my_float.should == 1.234
      obj.my_hash.my_date.should == Date.parse("25/12/2012")
    end

    it "should rename any hashes called class to archetype" do
      hash = {"class" => "Freaking Edge Cases!"}.with_indifferent_access
      obj = HashParser.new(hash)

      obj.archetype.should == "Freaking Edge Cases!"
    end

    it "should respond with N/A for any missing values" do
      hash = {:dps => 10}.with_indifferent_access
      obj = HashParser.new(hash)

      obj.flurry.should == "N/A"
    end
  end
end