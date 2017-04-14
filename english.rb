require './english_data.rb'

class English
  @@dictionary = {}
  @@prindex = {}

  def self.load
    %w{noun verb adj adv}.each { |part_of_speech| self.load_file("./english_data/data.#{part_of_speech}") }
  end

  def self.load_file(filename = './data.noun')
    puts "Loading '#{filename}'"
    File.readlines(filename).each do |line|
      next if line =~ /^\s/
      parse_for_dictionary(line)
      parse_for_index(line)
    end
    nil
  end

  def self.dictionary
    @@dictionary
  end

  def self.index
    @@prindex.keys.sort
  end

  def self.prindex
    @@prindex
  end

  def self.index_of(prindex)
    @@prindex.keys.index(prindex)
  end

  def self.parse_for_dictionary(line)
    header, definition = line.split(' | ')
    wordset = header.split(' ~ ').first
    definition_id, _dc, part_of_speech, _dc, word = wordset.split(' ')
    @@dictionary[word] ||= []
    @@dictionary[word] << {id: definition_id, part_of_speech: part_of_speech, definition: definition}
  end

  def self.parse_for_index(line)
    header, definition = line.split(' | ')
    wordset = header.split(' ~ ').first
    definition_id, _dc, part_of_speech, _dc, word = wordset.split(' ')
    @@prindex[definition_id] ||= []
    @@prindex[definition_id] << {word: word, part_of_speech: part_of_speech, definition: definition}
  end
end
