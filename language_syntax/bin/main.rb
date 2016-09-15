# def method_with_named_param(param_name: "default value")
  # puts param_name
# end


def my_name(first_name: "Joe", last_name: "Bloggs")
  puts "#{ first_name } #{ last_name }"
end

my_name(first_name: "Matt")