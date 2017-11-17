require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Catalog < Dry::Struct
      attribute :topic, Types::Strict::String
      attribute :name, Types::Strict::String
    end
  end
end