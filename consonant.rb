class Consonant
  @@all = []
  attr_reader :latin, :character, :alts

  CONSONANTS = {
    b:  {char: 'B', alts: ['P']},
    bl: {char: 'BL', alts: ['PL', 'BR', 'PR']},

    f:  {char: 'F', alts: ['V']},
    fl: {char: 'FL', alts: ['FR']},

    s:  {char: 'S'},
    # z:  {char: 'Z'},
    st: {char: 'ST'},
    sk: {char: 'SK'},
    sl: {char: 'SL'},
    sp: {char: 'SP'},
    sw: {char: 'SW'},

    g:  {char: 'G'},
    k:  {char: 'K'},
    gl: {char: 'GL', alts: ['GR']},
    kl: {char: 'KL', alts: ['KR']},

    j:  {char: 'J', alts: ['ZH']},
    sh: {char: 'SH'},
    ch: {char: 'CH'},
    d:  {char: 'D'},
    t:  {char: 'T'},

    h:  {char: 'H'},
    l:  {char: 'L', alts: ['R']},
    m:  {char: 'M'},
    n:  {char: 'N'},
    th: {char: 'TH'},
    w:  {char: 'W'},
    y:  {char: 'Y'},
  }

  def self.all
    keys.map { |k| self.new(k) }
  end

  def self.keys
    CONSONANTS.keys.sort
  end

  def initialize(key)
    data = CONSONANTS[key]
    raise ArgumentError.new("Invalid key: #{key}") unless data

    @character = data[:char]
    @latin = @character
    @alts = data[:alts] || []
  end

  def self.[](key)
    return self.new(self.keys[key]) if key.is_a? Integer
    return self.new(CONSONANTS[key.to_sym]) if key.is_a?(Symbol) || key.is_a?(String)

    if key.is_a? Range
      #TODO this is band not range

      raise ArgumentError.new('wat') unless self.keys.include?(key.first) && self.keys.include?(key.last)
      return self.keys[self.keys.index(first_key)..self.keys.index(last_key)].map { |k| self.new(k) }
    end

    raise ArgumentError.new "I couldn't figure out what you wanted me to look up with #{key.inspect}"
  end

  def self.count
    CONSONANTS.keys.count
  end

  def self.sample
    CONSONANTS[CONSONANTS.keys.sample]
  end

  def self.band(first_key, last_key)
    raise ArgumentError unless keys.include?(first_key) && keys.include?(last_key)
    keys[keys.index(first_key)..keys.index(last_key)]
  end

  def self.phonemes_for(key)
    Vowel.keys.map{ |v| CONSONANTS[key][:char] + Vowel[v][:char] }
  end
end

