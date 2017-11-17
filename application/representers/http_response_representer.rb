module WiKey

  class HttpResponseRepresenter < Roar::Decorator
    include Roar::JSON
    
    property :code
    property :message
    
    HTTP_CODE = {
      :ok => 200,
      :created => 201,
      
      :not_found => 404,
      :bad_request => 400,
      :conflict => 409,
      
      :internal_error => 500
    }.freeze
    
    def to_json
      http_message.to_json
    end
    
    def http_code
      HTTP_CODE[@represented.code]
    end
    
    private 
    
    def http_success?
      http_code < 300
    end
    
    def http_message
      {msg_or_error => [@represented.message]}
    end
    
    def msg_or_error
      http_success? ? :message : :error
    end
  end
end