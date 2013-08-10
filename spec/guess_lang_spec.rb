require File.join(__dir__, '..', 'guess_lang')

describe GuessLang, 'extract_vocab' do
  context 'when given sample text' do
    it 'should return the unique words in the text' do
      expect(GuessLang.extract_vocab('words words that are not unique unique')).to eq(%w/words that are not unique/)
    end
    it 'should ignore punctuation' do
      expect(GuessLang.extract_vocab('words, words: and more words; words.')).to eq(%w/words and more/)
    end
    it 'should ignore case' do
      expect(GuessLang.extract_vocab('words Words WORDS')).to eq(%w/words/)
    end
  end
end

describe GuessLang, 'load_samples' do
  context 'when there is one language file' do
    before do
      @contents = 'sample contents'
      @files = ['english.1']
      GuessLang.stub(:read_file).and_return(@contents)
    end
    after do
      GuessLang.load_samples(@files)
    end
    it 'should return the words in the file indexed by language file name' do
      expect(GuessLang.load_samples(@files)).to eq({'english.1' => @contents})
    end
  end
end

describe GuessLang, 'merge_vocabs' do
  context 'when there are multiple files for the same language' do
    before do
      @vocabs = {'english.1' => %w/a b c    /,
                 'english.2' => %w/    c d e/
                }
    end
    it 'should combine them into a single vocab' do
      expect(GuessLang.merge_vocabs(@vocabs)).to eq({'english' => %w/a b c d e/})
    end
  end
end

describe GuessLang, 'compare_vocabs' do
  it 'should return the number of matching words given 2 vocabs' do
    vocab1 = %w/a b c d      /
    vocab2 = %w/    c d e f  /
    vocab3 = %w/            g/
    expect(GuessLang.compare_vocabs(vocab1, vocab2)).to eq(2)
    expect(GuessLang.compare_vocabs(vocab2, vocab3)).to eq(0)
  end
end

describe GuessLang, 'find_best_match' do
  it 'should return the best matching language' do
    sample =             %w/a b c d e f g          /
    vocabs = {
              'lang2' => %w/    c d e f       j k l/,
              'best1' => %w/a b c d     g h i      /,
              'lang3' => %w/a               i j k l/
             }
    expect(GuessLang.find_best_match(sample, vocabs)).to eq('best1')
  end

  it 'should return "No match found" if the language cannot be determined at all' do
    sample =             %w/a b c      /
    vocabs = {'lang1' => %w/      d e f/}
    expect(GuessLang.find_best_match(sample, vocabs)).to eq('No match found')
  end
end

describe GuessLang, 'run' do
  context 'with sample files' do
    before do
      @unknown_file = 'unknown'
      @unknown_content = 'unknown content'
      @samples = ['english.1', 'english.2']
      @sample_content = "this is english content"

      Dir.should_receive(:glob).and_return(@samples)
      @samples.each do |sample|
        GuessLang.should_receive(:read_file).with(sample).and_return(@sample_content)
      end
      GuessLang.should_receive(:read_file).with(@unknown).and_return(@unknown_content)
      GuessLang.should_receive(:find_best_match).and_return('best')
    end
    it 'should output and return the best match' do
      expect(GuessLang.run(@unknown)).to eq('best')
    end
  end
end
