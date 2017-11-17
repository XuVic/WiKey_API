require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Paragraph < Dry::Struct
      attribute :content, Types::Strict::String
      attribute :catalog, Types::Strict::String
      attribute :topic, Types::Strict::String
    end
  end
end