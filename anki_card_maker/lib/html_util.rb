# common.rb

require './lib/html_ruby_util'
require './lib/html_builder'


include HtmlRubyUtil


module HtmlUtil

  HEC_LT = '&lt;'
  HEC_GT = '&gt;'

  MAIN_DIV = HtmlBuilder.new
  .div('main')
  .str
  .div_e
  .build

  HTML_LI = HtmlBuilder.new
  .li.str.li_e
  .build

  def self.to_html(array)
    str_builder = array.inject('') do |result, element|
      result += HtmlBuilder.BR + "\n" unless result.empty?
      result += to_html_raw(element)
    end

    return HtmlBuilder.new
    .div
    .str.lf
    .div_e
    .build % str_builder
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
    .pr.str.pr_e
    .div_e
    .build % str_builder
  end


  def self.to_figure_html(array)
    str_builder = array.inject('') do |result, element|
      result += "\n" unless result.empty?
      result += to_html_raw(element)
    end

    html_builder = HtmlBuilder.new
      .div
      .pre('fig')


  
  .pre_e
  .div_e
  .build

    return HTML_FIG % str_builder
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
      .li.text(li_text)
      .li_e
    end
  end

  def self.create_tags(tags)

    html_builder = HtmlBuilder.new
    .div('tag')

    first = true
    tags.each do |tag|
      html_builder.sp unless first

      # , 'Syntax'
      unless ['FB Only', 'BF Only'].include? tag
        html_builder.span.text(tag).span_e
      end
      first = false
    end

    return html_builder
    .lf
    .div_e
    .build

  end

end
