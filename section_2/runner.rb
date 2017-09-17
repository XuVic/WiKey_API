require 'pp'
require_relative 'user'

user = User.new "Vic@gmail.com", "Vic"

pp user
user.save