#!/usr/bin/env ruby

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

  def self.compare_vocabs(vocab1, vocab2)
    (vocab1 & vocab2).size
  end

  def self.find_best_match(sample, vocabs)
    scores = vocabs.map{|lang, vocab| [lang, compare_vocabs(sample, vocab)]}
    # [['lang1', 3], ['lang2', 1], ... ]
    puts "Scores: #{scores}" if ARGV.include? '-v'
    scores.sort_by!(&:last)
    # lowest first, highest last
    best_match = scores.last
    if best_match[1] == 0 # best match scored 0
      language = 'No match found'
    else
      language = best_match[0]
    end
    language
  end

  def self.run(file)
    # Load samples files
    files = Dir.glob(File.join(__dir__, 'samples', '*'))
    samples = load_samples(files).map{|filename, sample_text| self.extract_vocab sample_text}
    language_names = files.map{|full_path| File.basename full_path}
    vocabs = Hash[language_names.zip(samples)]
    vocabs = self.merge_vocabs(vocabs)
    # Load unknown file
    unknown_vocab = extract_vocab(read_file(file))
    language = self.find_best_match(unknown_vocab, vocabs)
    puts "File is #{language.capitalize}"
    language
  end
end

# if this file is being executed
if $0 == __FILE__
  if ARGV.size < 1 or ARGV.size > 2
    puts "Usage: #{$0} file-to-check.txt -v\nfile-to-check.txt is the file to analyse\n-v : verbose - print scores of each language"
  else
    GuessLang.run(ARGV[0])
  end
end
