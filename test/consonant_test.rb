require 'minitest/autorun'
require 'mocha/mini_test'
require './conlang.rb'

describe Consonant do
  it '#all returns a list of all consonants' do
    Consonant.all.must_be_kind_of Array
    Consonant.all.size.must_equal Consonant.keys.size
  end

  it '#all returns consonant objects' do
    Consonant.all.first.must_be_kind_of Consonant
  end

  it '#keys returns a list of all consonant keys' do
    Consonant.all.must_be_kind_of Array
    Consonant.keys.size.must_equal Consonant::CONSONANTS.size
  end

  it '#keys returns symbols' do
    Consonant.keys.first.must_be_kind_of Symbol
  end

  it '#count returns a count of all consonants' do
    Consonant.count.must_equal Consonant::CONSONANTS.size
  end

  describe '.new' do
    it 'returns a consonant object'
    it 'raises an exception if an invalid key is given'
    it 'sets the character'
    it 'sets the alts, if available'
    it 'sets the alts to an empty array, if none are available'
  end

  describe '.[]' do
    describe 'when given an integer' do
      it 'returns the consonant at that index'
      it 'returns nil if the index is out of range'
      it 'returns a consonant object'
    end

    describe 'when given a range' do
      it 'returns the consonants at the indexes in the range'
      it 'returns a truncated array if one end of the index is out of range'
      it 'returns an empty array if both ends of the index are out of range'
      it 'returns consonant objects'
    end

    describe 'when given a string' do
      it 'returns the consonant that matches the string'
      it 'returns a consonant object if it is found'
      it 'returns nil if it is not found'
    end

    describe 'when given a symbol' do
      it 'returns the consonant that matches the symbol'
      it 'returns a consonant object if it is found'
      it 'returns nil if it is not found'
    end

    describe 'when given anything else' do
      it 'raises an error'
    end
  end

  describe '.sample' do
    it 'chooses a random consonant'
    it 'returns a consonant object'
  end

  describe '.band' do
    #TODO: Is this rendered moot by the expanded .[]?
  end

  describe '#phonemes_for' do
    it 'returns a list of all phonemes that can be created for a consonant'
    it 'returns phoneme objects'
  end
end
