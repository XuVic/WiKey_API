require 'dry-struct'

module WiKey
  module Entity
    #Domian entity object for git sources
    class Topic < Dry::Struct
      attribute :origin_id, Types::Strict::Int
      attribute :name, Types::Strict::String
      attribute :rank, Types::Strict::Int
    
      
      def rankup
        topic = Database::TopicOrm.first(name: @name)
        topic.update(search_times: topic.search_times + 1)
      end
      
      def set_rank(rank)
        @rank = rank
      end
      
    end
  end
end