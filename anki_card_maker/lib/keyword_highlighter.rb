require './lib/obj_util'


class KeywordHighlighter


  COLOR_KEYWORD = '#7E0854'


  @@html_color = '<span style="color: %{color}">%{word}</span>'
  class << @@html_color
    def keyword(word) self % {color: COLOR_KEYWORD, word: word}; end
  end


  def initialize(keywords, comment_prefix)    
    raise 'Keywords required' unless keywords and not keywords.empty? and 
      not comment_prefix.empty?
    @keywords = keywords
    @comment_prefix = comment_prefix
    
  end


  def highlight(input_string)
    @keywords.each do |keyword|
      comment_index = ObjUtil.nvl(input_string.index(@comment_prefix), 10_000)  # Dummy max value.
      keyword_index = ObjUtil.nvl(input_string.index(keyword), -1)

      non_comment = keyword_index <= comment_index
      pattern = Regexp.new('\b' + Regexp.quote(keyword) + '\b')
      # pattern = Regexp.new('^[^#]*(' + Regexp.quote(keyword) + ')')

      has_keyword = pattern =~ input_string

      # favor readability over slight efficiency hit
      if non_comment and has_keyword
        input_string.gsub!(pattern, @@html_color.keyword(keyword))
      end

    end

    return input_string
  end

end