require 'spec_helper'

describe HashParser do
  describe 'hash_parser' do
    it 'converts a one level hash into an object with attributes' do
      obj = HashParser.new({foo: 'bar'})

      expect(obj.foo).to eq 'bar'
    end

    it 'converts a two level hash into an object with nested attributes' do
      obj = HashParser.new({foo: {bar: 'Excellent!'}})

      expect(obj.foo.bar).to eq 'Excellent!'
    end

    it 'converts a three level hash into an object with nested attributes' do
      obj = HashParser.new({foo: {bar: {excellent: 'YES!'}}})

      expect(obj.foo.bar.excellent).to eq 'YES!'
    end

    it 'keeps array attributes intact' do
      obj = HashParser.new({foo: ['bar', 'bar', 'brack', 'shreep']})

      expect(obj.foo.count).to eq 4
    end

    it 'keeps non-string values intact' do
      obj = HashParser.new(my_hash: {my_int: 5,
                                     my_float: 1.234,
                                     my_date: Date.parse('25/12/2012')})

      expect(obj.my_hash.my_int).to eq 5
      expect(obj.my_hash.my_float).to eq 1.234
      expect(obj.my_hash.my_date).to eq Date.parse('25/12/2012')
    end

    it 'should rename any hashes called class to archetype' do
      hash = {'class' => 'Freaking Edge Cases!'}.with_indifferent_access
      obj = HashParser.new(hash)

      expect(obj.archetype).to eq 'Freaking Edge Cases!'
    end

    it 'should respond with N/A for any missing values', unless: ENV['CI'] do
      hash = {dps: 10}.with_indifferent_access
      obj = HashParser.new(hash)

      expect(obj.flurry).to eq 'N/A'
    end
  end
end
