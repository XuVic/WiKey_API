require 'dry-struct'

module CodePraise

  module Entity
    
    class Summarizer
    
      def initialize(paragraph)
        @paragraph = paragraph
      end
      
      def build_matrix
        sentences = sentencer
        matrix = []
        (0...sentences.length).each do |i|
          matrix[i] = []
          (0...sentences.length).each do |j|
            if i != j
             common_word = find_common_word(sentences[i], sentences[j]) 
             score = intersection(sentences[i], sentences[j], common_word)
             matrix[i][j] = score
            else
             matrix[i][j] = 0
            end 
          end
        end
        matrix
      end
      
      private
      def sentencer
        sentences = @paragraph.split('.')
        sentences
      end
      
      def intersection(sentence_1, sentence_2, common_word)
        total_avg = (word_split(sentence_1).length + word_split(sentence_2).length)/2
        score = common_word.length.to_f/ total_avg
        score.round(2)
      end
      
      def find_common_word(sentence_1, sentence_2)
        word_1 = word_split(sentence_1)
        word_2 = word_split(sentence_2)
        hash = build_hash(word_1, word_2)
        common_word = []
        hash.keys.each do |k|
          common_word.push(k) if hash[k] == true
        end
        common_word
      end
      
      def word_split(paragraphe)
        paragraphe.split(' ')
      end
      
      def build_hash(word_1, word_2)
        hash = word_1.inject(Hash.new()) {|hash,word| hash[word] = false; hash}
        word_2.each do |w|
          hash[w] = true if hash.keys.include?(w)
        end
        hash
      end
    end
  end
end