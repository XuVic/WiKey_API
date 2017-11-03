require 'dry-struct'

module CodePraise
  module Entity
    #Domian entity object for git sources
    class Source < Dry::Struct
      attribute :id, Types::Strict::String
      attribute :name, Types::Strict::String
      attribute :description, Types::Strict::String
      attribute :category, Types::Strict::String
    end
  end
end