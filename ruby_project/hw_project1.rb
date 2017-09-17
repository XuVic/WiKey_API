dial_book = {
  "tw" => "886",
  "jp" => "445",
  "kr" => "228"
  }
  
def display_city_name(hash)
  hash.each {|k, v| puts k}
end

def display_city_number(hash,city)
  hash[city]
end

loop do
  puts "Do you want to lookup a city name?(Y/N)"
  ans = gets.chomp
  if (ans != "Y") 
    break
  end
  puts "Please enter your city name"
  display_city_name(dial_book)
  city_name = gets.chomp
  result = display_city_number(dial_book, city_name)
  if result.nil?
    puts "Your city can't be found."
  else
    puts "City name : #{city_name} City no : #{result}"
  end
end

