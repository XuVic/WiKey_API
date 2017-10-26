require_relative 'spec_helper'

describe 'Tests Praise library' do

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/cassettes'
    c.hook_into :webmock
    c.filter_sensitive_data('<GNEWS_tOKEN>') {GNEWS_TOKEN}
    c.filter_sensitive_data('<GNEWS_tOKEN_ESC>') {CGI.escape(GNEWS_TOKEN)}
  end
  
  before do 
    VCR.insert_cassette 'resources', record: :new_episodes
  end
  
  after do 
    VCR.eject_cassette
  end
  
  describe 'News information' do
    
    it 'HAPPY: should provid correct sources attributes' do
      sources = SourcePraise::GnewsAPI.new(GNEWS_TOKEN).sources
      
      _(sources.count).must_equal RESPONSE.count
      _(sources[0]).must_be_kind_of SourcePraise::Source
      _(sources[0].name).must_equal RESPONSE[0]['name']
    end
  end
  
  describe 'Articles information' do
    before do
      @sources = SourcePraise::GnewsAPI.new(GNEWS_TOKEN).sources
      @articles = SourcePraise::GnewsAPI.new(GNEWS_TOKEN).articles(@sources[0].id)
    end
    
    it 'HAPPY: should provid correct articles attributes' do
      _(@articles[0]).must_be_kind_of SourcePraise::Article
    end
    
    it 'HAPPY: should identify source' do
      _(@articles[0].source).must_equal @sources[0].id
    end
  end
  
end