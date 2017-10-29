require_relative 'spec_helper'

describe 'Tests Praise library' do


  before do 
    VCR.insert_cassette 'resources', record: :new_episodes
  end
  
  after do 
    VCR.eject_cassette
  end
  
  describe 'News information' do
    
    it 'HAPPY: should provid correct sources attributes' do
      api = CodePraise::Gnews::Api.new(GNEWS_TOKEN)
      sources_mapper = CodePraise::Gnews::SourcesMapper.new(api)
      sources = sources_mapper.load
      
      _(sources.count).must_equal RESPONSE.count
      _(sources[0]).must_be_kind_of CodePraise::Entity::Source
      _(sources[0].name).must_equal RESPONSE[0]['name']
    end
  end
  
  describe 'Articles information' do
    before do
      api = CodePraise::Gnews::Api.new(GNEWS_TOKEN)
      sources_mapper = CodePraise::Gnews::SourcesMapper.new(api)
      articles_mapper = CodePraise::Gnews::ArticlesMapper.new(api)
      @sources = sources_mapper.load
      @articles = articles_mapper.load(@sources[0].id)
    end
    
    it 'HAPPY: should provid correct articles attributes' do
      _(@articles[0]).must_be_kind_of CodePraise::Entity::Article
    end
    
    it 'HAPPY: should identify source' do
      _(@articles[0].source).must_equal @sources[0].id
    end
  end
  
end