class Tweet

  def respond_to?(method_name)
    method_name =~ /^hash_\w+/ || super
  end

  # New version 1.9.3
  def respond_to_missing?(method_name)
    method_name =~ /^hash_\w+/ || super
  end

end