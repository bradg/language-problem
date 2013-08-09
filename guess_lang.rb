class GuessLang

  def self.extract_vocab(text)
    text.downcase.gsub(/[.,;:]/,'').split(' ').uniq
  end
end
