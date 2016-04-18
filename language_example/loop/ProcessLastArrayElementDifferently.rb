# Process all element in an array treating the last element differently without using conditionals.

array = %w(1 2 3 4 5)

last = array.last
array_rest = array - [last]

# code for all except last
output = array_rest.inject('') do |result, element|
  result += element + ', '
end
output += last  # code for last

puts output

