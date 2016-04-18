require './lib/html_builder'
require './lib/html_util'
# require_relative 'html_builder'

class HtmlHelper


  ANSWER_ONLY_HTML = HtmlBuilder.new
    .span('answer_only').text('Answer Only').span_e.lf
  .build


  def initialize(tag_helper, front_array, back_array)
    @tag_helper = tag_helper

    html_builder = HtmlBuilder.new
      .style
        .select('div')
          .text_align('left')
        .select_e
        .select('span.answer_only')
          .font_weight('bold')
          .background_color('#D9534F')
          .color('white')
          .border_radius('5px')
          .padding('5px')
        .select_e

    shown_tags = tag_helper.visible_tags
    unless tag_helper.visible_tags.empty?
      html_builder
        .select('span.tag')
          .background_color('#5BC0DE')
          .color('white')
          .border_radius('5px')
          .padding('5px')
          .font_size('smaller')
        .select_e
    end

    if tag_helper.include? 'Figure'
      html_builder
        .select('.fig')
          .line_height('70%')
        .select_e
    end

    tag_html = HtmlUtil.create_tags(shown_tags) unless shown_tags.empty?
    style_html = html_builder.style_e.build

    @front = style_html
    @back = style_html

    @front += tag_html unless tag_html.nil?
    @back += tag_html unless tag_html.nil?

    if tag_helper.code_front?
      @front += HtmlUtil.to_code_html(front_array)
    else
      @front += HtmlUtil.to_html(front_array)
    end

    if tag_helper.ul?

      html_builder = HtmlBuilder.new
        .div
          .code
            .ul
      
      HtmlUtil.to_html_li(html_builder, back_array)
      
      html_builder
            .ul_e
          .code_e
        .div_e

      @back += html_builder.build

    elsif tag_helper.ol?

      html_builder = HtmlBuilder.new
        .div
          .code
            .ol
      
      HtmlUtil.to_html_li(html_builder, back_array)
      
      html_builder
            .ol_e
          .code_e
        .div_e
      @back += html_builder.build

    elsif tag_helper.code_back?
      @back += HtmlUtil.to_code_html(back_array)
    elsif tag_helper.figure?
      @back += HtmlUtil.to_figure_html(back_array)
    else
      @back += HtmlUtil.to_html(back_array)
    end

    if tag_helper.is_front_only?
      @back += ANSWER_ONLY_HTML
    elsif tag_helper.is_back_only?
      @front += ANSWER_ONLY_HTML
    end

  end


  def front_html
    @front
  end

  def back_html
    @back
  end

end
