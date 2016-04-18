require './lib/html_ruby_util.rb'
require 'test/unit'

class TestHtmlRubyUtil < Test::Unit::TestCase


  def test_highlight_quoted
    command = %q[puts("Hello" + " " + "World")]

    expected = 'puts(%s + %s + %s)' % %w[Hello \  World].collect do |element|
      '<span style="color: %s">"%s"</span>' % [HtmlRubyUtil::COLOR_QUOTE, element]
    end

    assert_equal(expected, HtmlRubyUtil.highlight_quoted(command))
  end


  def test_highlight_keywords
    command = %q[def method_name()]

    expected = '<span style="color: %s">def</span> method_name()' % HtmlRubyUtil::COLOR_KEYWORD

    assert_equal(expected, HtmlRubyUtil.highlight_keywords(command))
  end

end
