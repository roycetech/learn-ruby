require './lib/html_builder'
require './lib/html_ruby_util'


# Build Sequence:
# 1. Common Style
# 2. Specific Style for front then back
# 3. Common Html
# 4. Specific Html
# Don't show tags for one-sided cards
class HtmlHelper


  HEC_LT = '&lt;'
  HEC_GT = '&gt;'


  ANSWER_ONLY_HTML = HtmlBuilder.new
    .span('answer_only').text('Answer Only').span_e.lf


  attr_reader :front_html, :back_html


  def initialize(tag_helper, front_array, back_array)

    @tag_helper = tag_helper

    #  Step 1: Common Style
    style_common = HtmlBuilder.new
      .style
        .select('div')
          .text_align('left')
        .select_e

    shown_tags = tag_helper.visible_tags
    unless tag_helper.visible_tags.empty?
      style_common
        .select('span.tag')
          .background_color('#5BC0DE')
          .color('white')
          .border_radius('5px')
          .padding('5px')
          .font_size('smaller')
        .select_e
    end

    html_builder_front = HtmlBuilder.new(style_common)
    html_builder_back = HtmlBuilder.new(style_common)


    answer_only_style = StyleBuilder.new
      .select('span.answer_only')
        .font_weight('bold')
        .background_color('#D9534F')
        .color('white')
        .border_radius('5px')
        .padding('5px')
      .select_e

    html_builder_front.merge(answer_only_style) if tag_helper.is_back_only?
    html_builder_back.merge(answer_only_style) if tag_helper.is_front_only?

    if tag_helper.include? 'Figure'
      html_builder_back.merge(
        StyleBuilder.new
        .select('.fig')
          .line_height('70%')
        .select_e)
    end

    # End of Style ============================================================
    html_builder_front.style_e
    html_builder_back.style_e

    #  Step 3: Common HTML
    html_builder_common2 = HtmlBuilder.new
      .div.lf

    tags = build_tags
    
    # Process Front Card Html
    html_builder_front.merge(html_builder_common2)

    unless tag_helper.is_back_only?
      html_builder_front.merge(tags)
    end

    if tag_helper.code_front?
      if front_array.length == 1
        html_builder_front
          .pre
            .text(highlight_code(front_array))
          .pre_e.lf
      else
        html_builder_front
          .pre.lf
            .text(highlight_code(front_array)).lf
          .pre_e
      end

    else
      
      html_builder_front.br.text(front_array.inject('') do |result, element|
        result += HtmlBuilder::BR + "\n" unless result.empty?
        result += to_html_raw(element)
      end).lf

    end

    # Process Back Card Html
    html_builder_back.merge(html_builder_common2)
    unless tag_helper.is_front_only?
      html_builder_back.merge(tags)
    end

    if tag_helper.has_enum?
      html_builder_back
        .code.lf

      html_builder_back.__send__(tag_helper.ul? ? :ul : :ol).lf
      back_array.each do |element|
        li_text = HtmlRubyUtil.highlight_comment(to_html_nbsp(element))
        html_builder_back.li.text(li_text).li_e.lf
      end
      html_builder_back
        .__send__(tag_helper.ul? ? :ul_e : :ol_e).lf
        .code_e.lf
    elsif tag_helper.code_back?
      
      if back_array.length == 1
        html_builder_back
          .pre
            .text(highlight_code(back_array))
          .pre_e.lf
      else

        html_builder_back
          .pre
            .text(highlight_code(back_array)).lf
          .pre_e.lf
      end    

    elsif tag_helper.figure?
      html_builder_back
        .pre('fig').lf
          .text(back_array.inject('') do |result, element|
            result += "\n" unless result.empty?
            result += to_html_raw(element)
          end).lf
        .pre_e.lf
    
    else
      html_builder_back.text(back_array.inject('') do |result, element|
        result += HtmlBuilder::BR + "\n" unless result.empty?
        result += to_html_raw(element)
      end).lf
    end

    html_builder_front.merge(ANSWER_ONLY_HTML) if tag_helper.is_back_only?
    html_builder_back.merge(ANSWER_ONLY_HTML) if tag_helper.is_front_only?

    @front_html = html_builder_front.div_e.lf.build
    @back_html = html_builder_back.div_e.lf.build
  end


  private

  # build the tags html. <span>tag1</span>&nbsp;<span>tag2</span>...
  def build_tags
    first = true
    tags_html = HtmlBuilder.new
    @tag_helper.visible_tags.each do |tag|
      tags_html.space unless first
      tags_html.span('tag').text(tag).span_e
      first = false
    end
    tags_html.lf
  end


  def highlight_code(array)
    return array.inject('') do |result, element|
      result += "\n" unless result.empty?
      highlighted = HtmlRubyUtil.highlight_all(to_html_raw(element))
      
      if result.end_with? "</span>\n" and highlighted.start_with? "<span"
        result += HtmlBuilder::BR + highlighted
      else
        result += highlighted
      end
    end
  end

  # escape angles
  def to_html_raw(string)
    return string
    .gsub('<', HEC_LT)
    .gsub('>', HEC_GT)
  end

  # escape angles, and spaces
  def to_html_nbsp(string)
    return to_html_raw(string)
    .gsub('  ', HtmlBuilder::ESP * 2)
    .gsub(HtmlBuilder::ESP + ' ', HtmlBuilder::ESP * 2)
    .gsub("\n", HtmlBuilder::BR)
  end

end
