require 'dry-struct'

module CodePraise
  module Entity
    #Domian entity object for git sources
    class Article < Dry::Struct
      attribute :origin_id, Types::Strict::Int
      attribute :title, Types::Strict::String
      attribute :content, Types::Strict::String
    end
  end
end