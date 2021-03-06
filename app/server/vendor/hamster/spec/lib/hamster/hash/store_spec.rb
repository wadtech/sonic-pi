require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#store" do
    let(:hash) { Hamster.hash("A" => "aye", "B" => "bee", "C" => "see") }

    context "with a unique key" do
      let(:result) { hash.store("D", "dee") }

      it "preserves the original" do
        result
        hash.should eql(Hamster.hash("A" => "aye", "B" => "bee", "C" => "see"))
      end

      it "returns a copy with the superset of key/value pairs" do
        result.should eql(Hamster.hash("A" => "aye", "B" => "bee", "C" => "see", "D" => "dee"))
      end
    end

    context "with a duplicate key" do
      let(:result) { hash.store("C", "sea") }

      it "preserves the original" do
        result
        hash.should eql(Hamster.hash("A" => "aye", "B" => "bee", "C" => "see"))
      end

      it "returns a copy with the superset of key/value pairs" do
        result.should eql(Hamster.hash("A" => "aye", "B" => "bee", "C" => "sea"))
      end
    end

    context "with unequal keys which hash to the same value" do
      let(:hash) { Hamster.hash(DeterministicHash.new('a', 1) => 'aye') }

      it "stores and can retrieve both" do
        result = hash.store(DeterministicHash.new('b', 1), 'bee')
        result.get(DeterministicHash.new('a', 1)).should eql('aye')
        result.get(DeterministicHash.new('b', 1)).should eql('bee')
      end
    end

    context "when a String is inserted as key and then mutated" do
      it "is not affected" do
        string = "a string!"
        hash = Hamster.hash.store(string, 'a value!')
        string.upcase!
        hash['a string!'].should == 'a value!'
        hash['A STRING!'].should be_nil
      end
    end
  end
end