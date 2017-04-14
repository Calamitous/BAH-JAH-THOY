class WordDictionary
  TRANSLATE_TO_ENGLISH = {
    'KLOH-KAY-LEE'  => '00028270',
    'YOY-MAY-FOO'   => '07288215',
    'STOY-LOY-HAY'  => '07309599',
    'DOY-LEE-MAY'   => '15122231',
    'LOW-ZUH-MAW'   => '15245515',
    'BUH-BIH-LAY'   => '15270431',
    'THEE-BOY-JIGH' => '00007846',
    'HOW-FLOO-YEH'  => '05217688',
    'TAH-GUH-TIH'   => '06326797',
  }

  def self.define(word)
    return nil unless xlate_id = TRANSLATE_TO_ENGLISH[word]
    definition = English.index[xlate_id]
    puts definition
    "#{word}: #{definition[:word]} (#{definition[:part_of_speech]}) -- #{definition[:definition]}"
  end
end

