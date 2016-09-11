# 2. Use alias to access old method
class Square
  def print()
    puts("Square")
  end
end

  # Redefine class:
class Square
  alias_method :old_print, :print

  def print()
    puts("Logged")
    old_print()
  end
end

Square.new.print()