class GuessLang

  def self.extract_vocab(text)
    text.downcase.gsub(/[.,;:]/,'').split(' ').uniq
  end

  def self.load_samples(filenames)
    samples = Hash.new
    filenames.each do |filename|
      samples[filename] = self.read_file(filename)
    end
    samples
  end

  def self.read_file(filename)
    File.open(filename).read
  end

  def self.merge_vocabs(vocabs)
    merged_vocabs = Hash.new
    vocabs.each do |language_key, vocab|
      language = language_key.downcase.split('.')[0] # language is stuff before "."
      if merged_vocabs[language]
        merged_vocabs[language] = merged_vocabs[language] | vocab
      else
        merged_vocabs[language] = vocab
      end
    end
    merged_vocabs
  end
end
