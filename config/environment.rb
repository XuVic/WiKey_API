require 'roda'
require 'econfig'

module CodePraise
  
  class Api < Roda
    plugin :environments
    
    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'
    
    configure :development do 
      def self.reaload!
        exec 'ruby test.rb'
      end
    end
    
    configure :development, :test do 
      ENV['DATABASE_URL'] = 'sqlite://' + config.db_filename 
    end
    
    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL'])
      
      def self.DB
        DB
      end
    end
    
  end
  
end