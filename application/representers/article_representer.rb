# represent essential Wiki article information for API output
module CodePraise
  class ArticleRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :origin_id
    property :title
    property :content
  end
end