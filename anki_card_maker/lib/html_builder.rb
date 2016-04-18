require './lib/style_builder'

class HtmlBuilder


  BR = '<br />'

  ESP = '&nbsp;'
  LF = "\n"


  def initialize(value = '', indent = 0)
    @value = value
    @indent = indent
  end


  def style
    return StyleBuilder.new(self)    
  end

  def b
    @value += '<b>'
    return self
  end

  def b_e
    @value += '</b>'
    return self
  end

  def space
      @value += ESP
      return self
  end

  def br
      @value += BR + LF
      return self
  end


  def div(cls = nil)
    indent
    if cls
      @value += "<div class=\"%s\">\n" % cls
    else
      @value += "<div>\n"
    end
    
    @indent += 1
    return self
  end

  def div_e
    @value += "</div>\n"
    @indent -= 1
    indent
    return self
  end

  def lf
    @value += "\n"
    return self
  end
  
  def small(cls=nil)
    indent
    if cls
      @value += "<small class=\"%s\">" % cls
    else
      @value += '<small>'
    end   

    return self
  end

  def small_e(indented = true)
    indent if indented
    @value += "</small>\n"
    return self
  end

  def span(cls = nil)
    indent

    if cls
      @value += "<span class=\"%s\">" % cls
    else
      @value += "<span>"
    end
    
    # @indent += 1
    return self
  end

  def span_e
    # @indent -= 1
    indent
    @value += '</span>'
    return self
  end


  def ul
    @indent += 1
    indent
    @value += "<ul>\n"
    return self
  end

  def ul_e
    @indent -= 1
    indent
    @value += "</ul>\n"
    return self
  end


  def ol
    @indent += 1
    indent
    @value += "<ol>\n"
    return self
  end

  def ol_e
    @indent -= 1
    indent
    @value += "</ol>\n"
    return self
  end


  def li(text=nil)
    indent
    @value += '<li>'
    @value += text if text
    return self
  end

  def li_e
    indent
    @value += "</li>\n"
    return self
  end

  def pre(cls = nil)
    indent
    if cls
      @value += "<pre class=\"%s\">\n" % cls
    else
      @value += "<pre>\n"
    end   
    return self
  end

  def pre_e
    indent
    @value += "</pre>\n"
    return self
  end

  def code
    indent
    @value += "<code>\n"
    @indent += 1
    return self
  end

  def code_e
    indent
    @indent -= 1
    @value += "</code>\n"
    return self
  end

  def pr
    indent
    @value += '<pre>'
    return self
  end

  def pr_e
    indent
    @value += "</pre>\n"
    return self
  end

  def text(value)
    indent unless %w[span pre].include?(last_tag)
    @value += value
    return self
  end

  def str(indented = true)
    indent if indented and last_tag == 'pre'
    @value += '%s'
    return self
  end

  def last_tag
    if @value.include? '<'
      return @value[@value.rindex('<') + 1, 3]
    end
  end

  def indent
    if @indent > 0 and @value.end_with?(LF) and not @value[@value.rindex('<') + 1, 3] == 'pre'
      @value += ' ' * @indent
    end
  end


  def merge(value)
    @value += value
  end


  def build
    return @value
  end
  
  def inspect
    return @value.gsub(LF, '<new_line>')
  end

end


# puts HtmlBuilder.new
#   .style
#     .select('.tag')
#         .bgc('#5BC0DE')
#         .color('white')
#         .boder_radius('5px')
#         .padding('5px')
#     .unselect()  
#   .end_style
#   .div
#   .end_div
#   .build
  
