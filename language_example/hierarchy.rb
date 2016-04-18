begin
  1/0
rescue StandardError => errorObject
  print $! # this is the error object
rescue  # this is catch all
  print $! # this is the error object
end
