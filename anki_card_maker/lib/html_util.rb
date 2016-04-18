# common.rb

require './lib/html_ruby_util'
require './lib/html_builder'


include HtmlRubyUtil


module HtmlUtil

  HEC_LT = '&lt;'
  HEC_GT = '&gt;'


  def self.to_html(array)
    str_builder = array.inject('') do |result, element|
      result += HtmlBuilder.BR + "\n" unless result.empty?
      result += to_html_raw(element)
    end

    return HtmlBuilder.new
      .div
        .text(str_builder).lf
      .div_e
    .build
  end


  def self.to_code_html(array)

    str_builder = array.inject('') do |result, element|
      result += "\n" unless result.empty?

      highlighted = HtmlRubyUtil.highlight_all(to_html_raw(element))

      if result.end_with? "</span>\n" and highlighted.start_with? "<span"
        result += HtmlBuilder::BR + highlighted
      else
        result += highlighted
      end
    end

    return  HtmlBuilder.new
      .div
        .pr.text(str_builder).pr_e
      .div_e
    .build
  end


  def self.to_figure_html(array)
    str_builder = array.inject('') do |result, element|
      result += "\n" unless result.empty?
      result += to_html_raw(element)
    end

    return html_builder = HtmlBuilder.new
      .div
        .pre('fig')
          .text(str_builder).lf  
        .pre_e
      .div_e
    .build
  end

  def self.to_html_raw(string)
    return string
    .gsub('<', HEC_LT)
    .gsub('>', HEC_GT)
  end

  def self.to_html_rawbr(string)
    return string
    .gsub('<', HEC_LT)
    .gsub('>', HEC_GT)
    .gsub("\n", HtmlBuilder::BR)
  end

  def self.to_html_nbsp(string)
    return string
    .gsub('<', HEC_LT)
    .gsub('>', HEC_GT)
    .gsub('  ', HtmlBuilder::ESP * 2)
    .gsub(HtmlBuilder::ESP + ' ', HtmlBuilder::ESP * 2)
    .gsub("\n", HtmlBuilder::BR)
  end


  def self.to_html_li(html_builder, array)
    array.each do |element|
      li_text = HtmlRubyUtil.highlight_comment(to_html_nbsp(element))
      html_builder
        .li.text(li_text).li_e
    end
  end

  def self.create_tags(tags)

    html_builder = HtmlBuilder.new
      .div

    first = true
    tags.each do |tag|
      html_builder.space unless first
      html_builder.span('tag').text(tag).span_e
      first = false
    end

    return html_builder.lf
      .div_e
    .build

  end

end
