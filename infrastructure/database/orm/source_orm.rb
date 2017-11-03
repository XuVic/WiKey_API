module CodePraise
  module Database
    
    class SourceOrm < Sequel::Model(:sources)
      one_to_many :articles,
                  class: :'CodePraise::Database::ArticleOrm',
                  key: :id
      
      plugin :timestamps, update_on_create: true
    end
  end
end