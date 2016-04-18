class StyleBuilder
  

  def initialize(html_builder)    
    @prop_hash  = {}
    @prop_names  = []
    @html_builder = html_builder
    @value = "<style>\n"
    end

  def select(value)
    @value += value + ' {' +"\n"
    return self
  end

  def eselect

    @prop_names.sort!
    @prop_names.each do |name|
        value = @prop_hash[name]
        @value += "  %s: %s;\n" % [name, value]
    end

    @value += '}' +"\n"

    @prop_hash.clear
    @prop_names.clear

    return self
  end


  def estyle
    @value += "</style>\n"
    @html_builder.merge(@value)
    return @html_builder
  end

  def build
    return @value
  end


  def method_missing(meth, *args, &block)

    if args.length == 1
      dynamic_style(meth.to_s.gsub('_', '-'), args[0])
      return self
    else
      super
    end
  end
  
  private

  def dynamic_style(name, value)
    @prop_hash[name] = value
    @prop_names.push(name)
    # @value += '  ' + name + ': ' + value + ';' + "\n"
  end

end
