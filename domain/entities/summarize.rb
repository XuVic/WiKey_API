require 'dry-struct'
require 'ots'

module WiKey

  module Entity
    
    class Summary
      
      def initialize(paragraph)
        @paragraph = paragraph
      end
      
      def build_paragraph(n)
        paragraphs = ''
        summaries(n).each do |sentence|
          paragraphs << sentence[:sentence]
        end
        paragraphs
      end
      
      def ots
        OTS.parse(@paragraph)
      end
      
      def summaries(n)
        ots.summarize(percent: n.to_i)
      end
      
      def key_noun
        ots.topics
      end
      
      
    end
  end
end