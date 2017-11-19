# represent essential Wiki article information for API output
require_relative 'paragraph_representer'

module WiKey
  class ParagraphsRepresenter < Roar::Decorator
    include Roar::JSON
    
    collection :paragraphs, extend: ParagraphRepresenter
  end
end