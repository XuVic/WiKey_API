require 'dry-struct'
require 'ots'

module WiKey

  module Entity
    
    class Summary
      
      def initialize(paragraph)
        @paragraph = paragraph
      end
      
      def build_paragraph
        paragraphs = ''
        summaries.each do |sentence|
          paragraphs << sentence[:sentence]
        end
        paragraphs
      end
      
      def ots
        OTS.parse(@paragraph)
      end
      
      def summaries
        ots.summarize(percent: 50)
      end
      
      def key_noun
        ots.topics
      end
      
      
    end
  end
end