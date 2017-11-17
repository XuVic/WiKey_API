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
  
  describe 'Topic and Catalog information' do
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
    
    
  end
  
end