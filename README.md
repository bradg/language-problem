_guess_lang.rb_

Usage:

    guess_lang sample-file -v

will return the language of the sample-file or "No match found" if cannot determine language.

Sample language files are expected to be in /samples.

Eg.

    > guess_lang eng.txt
    File is English

Verbose option

    > guess_lang eng.txt -v
    Scores: [["english", 4], ["french", 0]]
    File is English

