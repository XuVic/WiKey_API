def multiply(first_number,second_number)
  first_number.to_f * second_number.to_f
end
def substruction(first_number,second_number)
  first_number.to_f - second_number.to_f
end
def addition(first_number,second_number)
  first_number.to_f + second_number.to_f
end
def divide(first_number,second_number)
  first_number.to_f / second_number.to_f
end
def mod(first_number,second_number)
  first_number.to_f % second_number.to_f
end
puts "please enter your first number"
first_number = gets.chomp
puts "please enter your second number"
second_number = gets.chomp
puts "which math operation do you want to chose"
operation = gets.chomp

if operation == '1'
  result = multiply(first_number,second_number)
elsif operation == '2'
  result = substruction(first_number,second_number)
elsif operation == '3'
  result = addition(first_number,second_number)
elsif operation == '4'
  result = divide(first_number,second_number)
elsif operation == '5'
  result = mod(first_number,second_number)
end

puts "result: #{result}"