module Demo
  def demo
    puts "demo"
  end
end

class User
  include Demo
  attr_accessor :name, :mail
  
  def initialize(name, mail)
    @name = name
    @mail = mail
  end
end

class Seller < User

end

user = User.new("Vic","Vic@gmail")

puts user.name
puts user.mail
user.demo
