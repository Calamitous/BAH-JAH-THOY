require './consonant.rb'
require './english.rb'
require './word_dictionary.rb'

English.load

class Integer
  # RELEASE THE MONKEYS!
  def commafy
    self.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
  end
end

class Vowel
  VOWELS = {
    ah:   {char:  'AH'},
    eh:   {char:  'EH'},
    ih:   {char:  'IH'},
    oh:   {char:  'OH'},
    uh:   {char:  'UH'},

    ay:   {char:  'AY'},
    ee:   {char:  'EE'},
    igh:  {char:  'IGH'},
    oy:   {char:  'OY'},

    aw:   {char:  'AW'},
    ow:   {char:  'OW'},
    oo:   {char:  'OO'},
  }

  def self.keys
    VOWELS.keys.sort
  end

  def self.[](key)
    VOWELS[key]
  end

  def self.count
    VOWELS.keys.count
  end

  def self.sample
    VOWELS[VOWELS.keys.sample]
  end
end

class Phoneme
  attr_reader :to_s, :index, :widge, :consonant, :vowel

  def initialize(consonant, vowel)
    @consonant, @vowel = consonant, vowel
    @to_s = consonant[:char] + vowel[:char]
    @index = Phoneme.index_of(@to_s)
  end

  def self.count
    Consonant.count * Vowel.count
  end

  def self.all
    Word.band(Consonant.keys.first, Consonant.keys.last)
  end

  def self.sample
    self.new(Consonant.sample, Vowel.sample)
  end

  def self.[](index)
    self.new(self.all[index].consonant, self.all[index].vowel)
  end

  def self.index_of(widge)
    self.all.each_with_index { |p, i| return i if p == widge }
    nil
  end

  def to_sigil
    Sigil.new(@index)
  end
end

class Word
  attr_reader :to_s, :index, :msp, :cp, :lsp

  PHONEMES_REQUIRED = 3

  def initialize(first, second = nil, third = nil)
    if second.nil? && third.nil?
      if first.kind_of?(String)
        return Word.new(*first.split('-'))
      elsif first.kind_of?(Fixnum)
        return self.at(first)
      end
    else
      @to_s = [first, second, third].join('-')
      @msp, @cp, @lsp = *([first, second, third].map { |pl| Phoneme[Phoneme.index_of(pl)] })
    end

    @index = (Phoneme.index_of(@msp) * (Phoneme.count ** 2)) +
             (Phoneme.index_of(@cp) * Phoneme.count) +
             Phoneme.index_of(@lsp)

    return self
  end

  def self.space
    Phoneme.count ** PHONEMES_REQUIRED
  end

  def self.sample
    self.new(Phoneme.sample, Phoneme.sample, Phoneme.sample)
  end

  def self.band(first_key, last_key)
    # TODO: This is currently ordered depth-first consonant to vowel.  Should it
    #       be ordered width-first?
    Consonant.band(first_key, last_key).map{ |c| Consonant.phonemes_for(c) }.flatten
  end

  def self.sample_row(width)
    ([nil] * width).map{ self.sample }.join("\t")
  end

  def self.sample_table(width = 5, height = 10)
    ([nil] * height).map{ sample_row(width) }.join("\n")
  end

  def self.at(idx)
    if idx > (self.space - 1) || idx < 0
      raise ArgumentError.new("Valid indexes are from 0 to #{self.space - 1}")
    end

    phoneme_count = Phoneme.count
    digit_stack   = []

    while(idx != 0) do
      rem = idx % phoneme_count
      idx /= phoneme_count
      digit_stack.unshift(rem)
    end

    digit_stack = ([0, 0, 0] + digit_stack)[-3..-1]

    Word.new *digit_stack.map{ |v| Phoneme[v] }
  end

  def to_sigils
    [@msp, @cp, @lsp].map { |p| p.to_sigil }
  end

  def to(language)
    raise ArgumentError.new("Unknown language: #{language.to_s}") unless [:english].include?(language)
    lang_class = Object.const_get(language.to_s.capitalize)
    lang_class.prindex[lang_class.index[@index]]
  end

  def self.from(language, prindex)
    raise ArgumentError.new("Unknown language: #{language.to_s}") unless [:english].include?(language)
    lang_class = Object.const_get(language.to_s.capitalize)
    Word.at(lang_class.index_of(prindex))
  end

  def method_missing(method, *args, &block)
    super if method.to_s !~ /^to_.+/ || [:to_str, :to_ary].include?(method)
    language = method.to_s.gsub(/^to_/, '').to_sym
    self.send(:to, language)
  end
end

class Sigil
  attr_reader :index, :top, :center, :bottom
  @@bar_pos = %w{| - | - \\ / \\ / o}

  def initialize(index)
    @index = index
    bits = [7, 0, 4, 3, 1, 8, 6, 2, 5].map { |b| self.has?(b) ? b : nil }
    bars = bits.map { |b| b.nil? ? ' ' : @@bar_pos[b] }

    @top = bars[0..2].join + ' '
    @center = bars[3] + '.' + bars[4..5].join
    @bottom = bars[6..8].join + ' '
  end

  def has?(bitpos)
    return ' ' if bitpos.nil?
    @index & (1 << bitpos) != 0
  end

  def +(sigil)
    @top += sigil.top
    @center += sigil.center
    @bottom += sigil.bottom
  end

  def to_s
    [@top, @center, @bottom].join("\n")
  end
end

class Number
  NUMBER_PREFIX = 'MOW'
  NUMERIC_BASE_PREFIX = 'TOH'

  def self.digits
    Phoneme.all.map{ |p| Word.new(NUMBER_PREFIX, zero, p).to_s }
  end

  def self.zero
    Phoneme.all.first
  end

  def self.base(radix)
    Number.digits[radix].gsub(NUMBER_PREFIX, NUMERIC_BASE_PREFIX)
  end

  def self.[](index)
    digits[index]
  end
end

class Calendar
  CALENDRICAL_PREFIX = 'SAH'
  MONTH_PREFIX       = 'JIH'
  WEEKDAY_PREFIX     = 'BIGH'
  MONTHDAY_PREFIX    = 'NOO'

  def self.months
    Array(1..13).map do |index|
      Word.new(CALENDRICAL_PREFIX, MONTH_PREFIX, Phoneme[index]).to_s
    end
  end

  def self.weekdays
    Array(1..7).map do |index|
      Word.new(CALENDRICAL_PREFIX, WEEKDAY_PREFIX, Phoneme[index]).to_s
    end
  end

  def self.monthdays
    Array(1..28).map do |index|
      Word.new(CALENDRICAL_PREFIX, MONTHDAY_PREFIX, Phoneme[index]).to_s
    end
  end

  def self.from_date(date)
    [
      Number[date.year / 100],
      Number[date.year % 100],
      self.months[date.yday / 28],
      self.monthdays[date.yday % 28]
    ].join(' ')
  end
end

class Clock
end

def dump
  puts
  puts "#{Consonant.count} consonants, #{Vowel.count} vowels"
  puts "#{Phoneme.count} possible phonemes, #{Word::PHONEMES_REQUIRED} phonemes per word, #{Word.space.commafy} possible words"
  puts

  puts "Sample word table:"

  puts Word.sample_table

  puts Word.sample.to_sigils
end
