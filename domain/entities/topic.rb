require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Topic < Dry::Struct
      attribute :origin_id, Types::Strict::Int
      attribute :name, Types::Strict::String
    end
  end
end