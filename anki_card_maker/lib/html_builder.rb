require './lib/style_builder'
require 'logger'

# end tags have the format tag_e
# if end tag, new line is appended when value is true
# for text tag, the value is the actual text.
# no need for manual lf on styles.
class HtmlBuilder


  SpecialTags = %w(text lf space br style style_e)
  Tag_Span_E = 'span_e'
  Tag_BR = 'br'

  BR = '<br />'
  ESP = '&nbsp;'
  LF = "\n"


  @@logger = Logger.new(STDOUT)
  

  @@logger.formatter = proc do |severity, datetime, progname, msg|
    # subscript 3 for eclipse/commandline, 4 for sublime 2
    line = caller[3]
    source = line[line.rindex('/', -1)+1 .. -1]
    "#{severity} #{source} - #{msg}\n"
  end


  attr_reader :styled, :last_tag


  def initialize(html_builder = nil)
    @tags = []
    @values = []
    @styled = false

    merge(html_builder) if html_builder
  end


  def to_s
    return_value = LF + self.class.to_s + '------------------------------------'+ LF
    return_value += '  Styled [%s]' % (styled ? 'Y' : 'n') + LF + '  Tags:' + LF

    @tags.each_index do |index|
      return_value += "  %-8s => %s\n" % [@tags[index], @values[index]]
    end
    return_value
  end


  def style
    raise 'You cannot style twice!' if @styled
    @styled = true
    return StyleBuilder.new(self)
  end

  # # when you accidentally try to add a new style to an html builder instead of style_builder.
  # def select(selector)
  #   return StyleBuilder.new(self).select(selector)
  # end


  # Accepts html another HtmlBuilder or StyleBuilder.
  # Style should come first! :)
  def merge(builder)
    if builder.is_a? StyleBuilder

      if @styled
        unless @values.empty?
          last = @values.pop
          last += builder.value
          @values.push(last)
        end
      else
        @tags.push('style')
        @values.push(builder.value)
        @styled = true
      end
      return StyleBuilder.new(self)

    elsif builder.is_a? HtmlBuilder
      raise 'Second builder cannot have a style' if builder.styled

      @styled ||= builder.styled
      unless @tags.last == 'lf'
        @tags.push('lf')
        @values.push nil
      end

      builder.each_with_value do |tag, value|
        @tags.push(tag)
        @values.push(value)
      end
      return self
    end 
  end


  def build

    return_value = ''
    level = 0
    last_tag = nil
    last_tag_closed = nil
    last_lfed = false  # last tag invoked new line

    self.each_with_value do |tag, value|

      is_open_tag = !tag.include?('_')
      unless SpecialTags.include?(tag)
        do_indent = level > 0  && last_lfed
        if is_open_tag
          return_value += ' ' * (2 * level) if do_indent
          level += 1
        else
          level -= 1
          return_value += ' ' * (2 * level) if do_indent
        end
      end

      if tag == 'text' and last_lfed and not last_tag == 'pre'
        return_value += ' ' * (2 * level)
      end
      
      # puts 'lf: [%s], prev: %6s, tag: %-7s, level: %s, %5s, indent: [%5s], value: %13s' % 
      #   [last_lfed ? 'Y': 'n', last_tag, tag, level, is_open_tag ? 'Open' : 'Close', do_indent, value]

      case tag
      when 'space' then
        return_value += ESP
      when 'lf' then
        return_value += LF
      when 'br' then
        return_value.chomp!
        return_value += BR + LF
      when 'text' then
        return_value += value
      when 'style' then
        return_value += "<style>\n" + value
      else

        if is_open_tag
          klass = ' class="%s"' % value if value
          return_value += '<%{tag}%{klass}>' % {tag: tag, klass: klass }
          tag_name = tag
        else
          tag_name = tag[0...tag.index('_')]
          return_value += '</%s>' % tag_name
        end

      end

      last_tag = tag unless SpecialTags.include?(tag)
      last_lfed = %q(lf br).include?(tag)

    end  # each loop

    return return_value
  end


  # Will handle tag and tag_e only.
  def method_missing(meth, *args, &block)
    if args.length <= 1
      @tags.push(meth.to_s)
      is_end_tag = meth.to_s.include?('_e')
      if is_end_tag and args.empty?
        @values.push(true)
      else
        @values.push(args[0])
      end

      @last_tag = meth.to_s unless SpecialTags.include? meth.to_s

      return self
    else
      super
    end    
  end

  def size
    return @values.size
  end

  def insert(tag, value=nil)
    @tags.insert(tag)
    @values.insert(value)
    return self
  end

  protected


  def each_with_value
    # copy = @tags.clone
    # copy.each_index { |index| yield copy[index], copy[index] }
    @tags.each_index do |index|
      yield @tags[index], @values[index]
    end
  end

end


# puts HtmlBuilder.new
#   .div('main').lf
#     .code.lf
#       .span.text('Hello').span_e.space.span.text('World').span_e.lf
#   .code_e.lf
#   .div_e
# .build
# puts


# two = HtmlBuilder.new
#   .div.lf
#     .ol.lf
#       .li.text('Item 2').li_e.lf
#     .ol_e.lf
#     .pre.text('Pre formatted 2').pre_e.lf
#   .div_e
#
# three = HtmlBuilder.new
#   .style
#     .select('.tag')
#       .color('red')
#     .select_e
#     .select('pre')
#       .padding('5px')
#     .select_e
#   .style_e
#   .div.lf
#     .ol.lf
#       .li.text('Item').li_e.lf
#     .ol_e.lf
#     .pre.text('Pre formatted').pre_e.lf
#   .div_e

# puts three.merge_builder(two).build