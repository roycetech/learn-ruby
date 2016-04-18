#!/usr/bin/env ruby

require './lib/obj_util'

module HtmlRubyUtil

  COLOR_COMMENT = '#417E60'
  COLOR_CLASS_VAR = '#426F9C'
  COLOR_KEYWORD = '#7E0854'
  COLOR_QUOTE = '#1324BF'
  COLOR_IDENTIFIER = '#693E3F'

  @@html_color = '<span style="color: %{color}">%{word}</span>'
  class << @@html_color
    def comment(string) self % {color: COLOR_COMMENT, word: string}; end
    def identifier(string) self % {color: COLOR_IDENTIFIER, word: string}; end
    def keyword(word) self % {color: COLOR_KEYWORD, word: word}; end
    def quote(string) self % {color: COLOR_QUOTE, word: string}; end
  end

  def self.highlight_keywords(string)
    unless @keywords
      @keywords = File.read('./data/keywords_ruby.txt').lines.collect do |line|
        line.chomp
      end
    end

    @keywords.each do |keyword|
      comment_index = ObjUtil.nvl(string.index('# '), 10_000)  # Dummy max value.
      keyword_index = ObjUtil.nvl(string.index(keyword), -1)

      non_comment = keyword_index <= comment_index
      has_keyword = Regexp.new('\b' + Regexp.quote(keyword) + '\b') =~ string

      # favor readability over
      if  non_comment and has_keyword
        string.gsub!(Regexp.new(keyword), @@html_color.keyword(keyword))
      end

    end
    string
  end

  def self.highlight_quoted(string)
    pattern = %r{(["'])(\\\1|[^\1]*?)\1}
    string.gsub!(pattern, @@html_color.quote('\1\2\1'))
    return string
  end

  def self.highlight_comment(string)
    pattern = /# .*$/
    if pattern =~ string
      string.sub!(pattern, @@html_color.comment(string[pattern]))
    end
    return string
  end

  def self.highlight_comment_br(string)
    return highlight_comment(string) + HtmlUtil::TAG_BR
  end

  # Added <br/ > as workaround to quirk of missing new lines.
  def self.highlight_block_param(string)
    pattern = Regexp.new %Q{\\|[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*\\|}
    if pattern =~ string
      string.sub!(pattern, @@html_color.identifier(string[pattern]))
    end
    string
  end

  # highlight instance and class variables
  def self.highlight_variable(string)
    pattern = /@[@a-z_A-Z]*\s/
    if pattern =~ string
      string.sub!(pattern, '<span style="color: %s">' %  COLOR_CLASS_VAR +
      string[pattern] + '</span>')
    end
  end

  # Some spaces adjacent to tags need to be converted because it is not honored by
  # <pre> tag.
  def self.space_to_nbsp(string)

    pattern_between_tag = /> +</
    while pattern_between_tag =~ string
      lost_spaces = string[pattern_between_tag]
      string.sub!(pattern_between_tag, '>' + ('&nbsp;' * (lost_spaces.length - 2)) + '<')
    end

    pattern_before_tag = /^\s+</
    if pattern_before_tag =~ string
      lost_spaces = string[pattern_before_tag]
      string.sub!(pattern_before_tag, (HtmlBuilder::ESP * (lost_spaces.length - 1)) + '<')
    end

  end

  def self.highlight_all(string)

    highlight_quoted(string)
    highlight_keywords(string)
    highlight_comment(string)
    highlight_block_param(string)
    highlight_variable(string)
    space_to_nbsp(string)
    string

  end

  def self.execute
    puts highlight_keywords("def method_test_string")
  end

end
