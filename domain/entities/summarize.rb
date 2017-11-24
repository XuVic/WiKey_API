require 'dry-struct'
require 'epitome'

module WiKey

  module Entity
    
    class Summarize
      
      def initialize(paragraph)
        @paragraph = paragraph
      end
      
      def summarize
        corpus = build_corpus(build_document)
        corpus.summary(length=2)
      end
      
      private
      def build_document
        collection = []
        @paragraph.split('.').each do |sentence|
          collection.push(Epitome::Document.new(sentence))
        end
        collection
      end
      def build_corpus(document_collection)
        corpus = Epitome::Corpus.new(document_collection)
        corpus
      end
      
    end
  end
end