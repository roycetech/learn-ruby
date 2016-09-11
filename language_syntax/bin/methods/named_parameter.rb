# 1. Named Parameter with default value.
def tweet(param_name: "default value")
  puts param_name
end

tweet()
tweet(param_name: "Royce")


# 2. Named Parameter using Hash
def say(message, options={})
  puts(options[:long])
  puts(options[:lat])
end
say("Hello", long: 1, lat: 2)
