module CodePraise

  class SourceRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :id
    property :name
    property :description
    property :category
  end 
end