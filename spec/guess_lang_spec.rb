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
      @vocabs = {'lang.1' => %w/a b c    /,
                 'lang.2' => %w/    c d e/
                }
    end
    it 'should combine them into a single vocab' do
      expect(GuessLang.merge_vocabs(@vocabs)).to eq({'lang' => %w/a b c d e/})
    end
  end
end
