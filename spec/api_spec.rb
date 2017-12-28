require_relative 'spec_helper.rb'

describe 'Tests WiKey library' do
  CASSETTE_FILE_2 = 'wikey_api'.freeze
  API_VER = 'api/v0.1'.freeze
  before do
    VCR.insert_cassette CASSETTE_FILE_2,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end    
  
  describe 'Wiki information' do
    before do
      app.DB[:paragraphs].delete
      app.DB[:catalogs].delete
      app.DB[:topics].delete
    end
    
    describe 'Posting to create entity from Wiki' do
      it 'HAPPY : should retrieve and store topic, catalog and paragraphs' do
        post API_VER + "/topic/#{TOPIC_NAME}"
      
        response_data = JSON.parse last_response.body
        _(last_response.status).must_equal 201
        _(response_data.size).must_be :>, 0
      end
      
      it 'SAD : should report error if no topic found in wiki' do
        post API_VER + "/topic/wrong_topic"
        
        _(last_response.status).must_equal 400
      end
      
      it 'BAD : should report error if duplicate wiki topic found' do
        post API_VER + "/topic/#{TOPIC_NAME}"
        _(last_response.status).must_equal 201
        post API_VER + "/topic/#{TOPIC_NAME}"
         _(last_response.status).must_equal 409
      end
    end
    
    describe 'Getting to correct data from DB' do
      before do 
        post API_VER + "/topic/#{TOPIC_NAME}"
      end
      
      it 'HAPPY : Should get all topics' do
        get API_VER + "/topics"
        
        response_data = JSON.parse last_response.body
        _(last_response.status).must_equal 200
        _(response_data.size).must_be :>, 0
      end
      it 'SAD : There are no data in DB' do
        app.DB[:paragraphs].delete
        app.DB[:catalogs].delete
        app.DB[:topics].delete
        get API_VER + '/topics'
        _(last_response.status).must_equal 404
      end
      
      it 'HAPPY : Should get topic, catalogs and default paragraphs' do
        get API_VER + "/topic/#{TOPIC_NAME}"
        
        response_data = JSON.parse last_response.body
        _(response_data.keys.count).must_equal 3
        _(response_data['paragraphs'][0]['catalog']).must_equal 'default'
      end
      it 'SAD : Topic not in DB' do
        get API_VER + '/topic/gogoro'
        
        _(last_response.status).must_equal 404
      end
      
      it 'HAPPY : Should get specific paragraphs with specific catalog' do
        get API_VER + "/paragraphs/#{TOPIC_NAME}/Etymology"
        
        response_data = JSON.parse last_response.body
        _(response_data.keys.count).must_equal 3
        _(response_data['paragraphs'][0]['catalog']).must_equal 'Etymology'
      end
      it 'SAD : Catalog not exist' do
        get API_VER + "/paragraphs/#{TOPIC_NAME}/wrong_catalog"
        
        _(last_response.status).must_equal 404
      end
    end
    
    describe 'Getting mulitple topics which related to main topic' do
      before do 
        post API_VER + "/topic/#{TOPIC_NAME}"
      end
      
      it 'HAPPY : Should get mulitple topics with default paragraphs' do
        get API_VER + "/see_also/#{TOPIC_NAME}"
        _(last_response.status).must_equal 202
        id = JSON.parse last_response.body
        _(id['id']).must_be_kind_of Integer
        5.times { sleep(1); print '.' }
        
        get API_VER + "/see_also/#{TOPIC_NAME}"
        _(last_response.status).must_equal 200
        
      end
      
    end
    
  end
  
end