=begin 
   Process all element in a hash treating the last element differently without 
   using conditionals.  Since hash do not heave a meaningful order, we will just 
     treat a random element, in this case I chose first' as the 'last' element
=end

hash = { :a => 1, :b => 2, :c => 3, :d => 4, :e => 5 }

first = hash.first


hash_rest = hash.clone
hash_rest.delete first[0]

# code for all except last
output = hash_rest.inject('') do |result, element|
  key = element[0]
  value = element[1]
  result += key.to_s + ' => ' + value.to_s + ', '
end

output += first[0].to_s + ' => ' + first[1].to_s  # code for 'last'

puts output

