require_relative 'spec_helper'

describe 'Tests Praise library' do
  API_VER = 'api/v0.1'.freeze

  before do 
    VCR.insert_cassette 'codepraise_api', record: :new_episodes
  end
  
  after do 
    VCR.eject_cassette
  end
  
  describe 'Source information' do
    it 'HAPPY: should provide correct source attributes' do
      get "#{API_VER}/sources"
      #_(last_response.status).must_equal 200
    end
  end
  
end