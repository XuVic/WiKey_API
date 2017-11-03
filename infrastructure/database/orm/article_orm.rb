module CodePraise
  module Database
    
    class ArticleOrm < Sequel::Model(:articles)
      many_to_one :source,
                  class: :'CodePraise::Database::SourceOrm'
    
      plugin :timestamps, update_on_create: true
    end
  end
end