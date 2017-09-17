require 'json'

class User
  attr_accessor :email, :user, :permission
  
  def initialize(*args)
    @email = args[0]
    @user = args[1]
    @permission = User.set_permission
  end
  
  def self.set_permission
    file = File.read 'user_permission_template.json'
    JSON.load(file, nil, symbolize_name:true)
  end
  
  def save
    self_json = {email:@email, user:@user, permission:@permission}.to_json
    open('user.json', 'a') do |file|
      file.puts self_json
    end
  end
end