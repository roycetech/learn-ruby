# 1. Literal
puts /abc/


# 2. Literal with options
puts /abc/mi


# 3. Constructor
puts Regexp.new("abc")


# 4. Constructor with options
puts Regexp.new("abc", Regexp::MULTILINE | Regexp::IGNORECASE)


# 5. Percent notation
puts %r"abc"


# 6. Percent notation with option
puts %r"abc"i