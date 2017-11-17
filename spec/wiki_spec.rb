require_relative 'spec_helper.rb'

describe 'Tests WiKey Mapper and Gateway' do
  CORRECT = YAML.safe_load(File.read('spec/fixtures/cassettes/wikey.yml'))
  record = CORRECT['http_interactions'][0]['response']['body']['string']
  record = JSON.parse record
  RESPONSE = record['query']['pages']['25734']
  CASSETTE_FILE = 'wikey'.freeze
  gateway = WiKey::Wiki::Api

  before do 
    VCR.insert_cassette CASSETTE_FILE, record: :new_episodes
  end
  
  after do 
    VCR.eject_cassette
  end
  
  describe 'Topic and Catalog information' do
    it 'HAPPY : It should provide correct wiki informaitom with correct format.' do
      topic_mapper = WiKey::Wiki::TopicMapper.new(gateway)
      catalog_mapper = WiKey::Wiki::CatalogMapper.new(gateway)
      topic = topic_mapper.load(TOPIC_NAME)
      catalog = catalog_mapper.load(TOPIC_NAME)
      correct_topic = WiKey::Wiki::TopicMapper::DataMapper.new(RESPONSE).build_entity
      correct_catalog = WiKey::Wiki::CatalogMapper::DataMapper.new(RESPONSE).build_entity
      _(topic.name).must_equal correct_topic.name
      _(catalog.size).must_equal correct_catalog.size
    end
  end
  
  describe 'Paragraphs informaitom' do
    it 'HAPPY : It should provide coorect paragraph information with correct catalog' do 
      paragraph_mapper = WiKey::Wiki::ParagraphMapper.new(gateway)
      paragraphs = paragraph_mapper.load(TOPIC_NAME)
      correct_paragraphs = WiKey::Wiki::ParagraphMapper::DataMapper.new(RESPONSE).build_entity
      
      _(paragraphs[0].topic).must_equal correct_paragraphs[0].topic
      _(paragraphs.size).must_equal correct_paragraphs.size
    end
  end
  
  describe 'Wrong topic' do
    it 'SAD : It should raise correct wrong msg.' do
      proc do 
        topic_mapper = WiKey::Wiki::TopicMapper.new(gateway)
        topic_mapper.load('')
      end.must_raise WiKey::Wiki::Api::Errors::Empty
      proc do 
        topic_mapper = WiKey::Wiki::TopicMapper.new(gateway)
        topic_mapper.load('sadfsad')
      end.must_raise WiKey::Wiki::Api::Errors::NotFound
      proc do 
        topic_mapper = WiKey::Wiki::TopicMapper.new(gateway)
        topic_mapper.load('tw')
      end.must_raise WiKey::Wiki::Api::Errors::Ambitigous
    end
  end
  
  
end