require File.join(__dir__, '..', 'guess_lang')

describe GuessLang, 'extract_vocab' do
  context 'when given sample text' do
    it 'should return the unique words in the text' do
      GuessLang.extract_vocab('words words that are not unique unique').should == %w/words that are not unique/
    end
    it 'should ignore punctuation' do
      GuessLang.extract_vocab('words, words: and more words; words.').should == %w/words and more/
    end
    it 'should ignore case' do
      GuessLang.extract_vocab('words Words WORDS').should == %w/words/
    end
  end
end
