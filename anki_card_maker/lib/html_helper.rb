require './lib/html_builder'
require './lib/base_highlighter'


# Build Sequence:
# 1. Common Style
# 2. Specific Style for front then back
# 3. Common Html
# 4. Specific Html
# Don't show tags for one-sided cards
class HtmlHelper


  HEC_LT = '&lt;'
  HEC_GT = '&gt;'


  attr_reader :front_html, :back_html


  def initialize(highlighter, tag_helper, front_array, back_array)

    @tag_helper = tag_helper
    @highlighter = highlighter

    #  Step 1: Common Style
    style_common = HtmlBuilder.new
      .style
        .select('.main')
          .text_align('left')
        .select_e
        .select('code')
          .font_family("'Courier New'")
          .background_color('#F1F1F1')
          .border_radius('5px')
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

    if tag_helper.command?
      html_builder_front.merge(StyleBuilder.new
        .select('code.command')
          .color('white')
          .background_color('black')
        .select_e)
    end

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
      .div('main').lf

    tags = build_tags(back_array)
    
    # Process Front Card Html
    html_builder_front.merge(html_builder_common2)

    has_visible_tag = !tag_helper.visible_tags.empty?    
    unless tag_helper.is_back_only? or not has_visible_tag
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

    elsif tag_helper.command?
        html_builder_front
          .div.lf
            .code('command')

        html_builder_front.text(front_array.inject('') do |result, element|
          result += HtmlBuilder::BR + "\n" unless result.empty?
          result += to_html_raw(element)
        end).lf

        html_builder_front
          .code_e.lf
          .div_e.lf
    else
      html_builder_front.br if has_visible_tag
      html_builder_front.text(front_array.inject('') do |result, element|
        result += HtmlBuilder::BR + "\n" unless result.empty?
        result += to_html_raw(element)
      end).lf

    end

    # Process Back Card Html
    html_builder_back.merge(html_builder_common2)

    unless tag_helper.is_front_only? or not has_visible_tag
      html_builder_back.merge(tags)
    end

    if tag_helper.has_enum?
      # html_builder_back
      #   .code.lf

      html_builder_back.__send__(tag_helper.ul? ? :ul : :ol).lf

      back_array.each do |element|        
        if tag_helper.code_back?
          li_text = @highlighter.highlight_all(to_html_nbsp(element))
        else
          li_text = to_html_nbsp(element)
        end
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

      html_builder_back.br if has_visible_tag and not tag_helper.is_front_only?
      html_builder_back.text(back_array.inject('') do |result, element|
        result += (HtmlBuilder::BR + "\n") unless result.empty?
        result += to_html_raw(element)
      end).lf
      
    end


    if tag_helper.is_front_only?
      backAnswer = HtmlBuilder.new
        .span('answer_only').text('Answer Only').span_e.lf

      # $logger.debug(html_builder_back.build)
      html_builder_back.br.br unless tag_helper.has_enum?

      backAnswer.insert(HtmlBuilder::Tag_BR)  if html_builder_back.last_tag == HtmlBuilder::Tag_Span_E or html_builder_back.last_element == 'text'
      html_builder_back.merge(backAnswer)
    end

    if tag_helper.is_back_only?
      frontAnswer = HtmlBuilder.new
        .span('answer_only').text('Answer Only').span_e.lf

      html_builder_front.br.br unless tag_helper.has_enum?

      frontAnswer.insert(HtmlBuilder::Tag_BR)  if html_builder_front.last_tag == HtmlBuilder::Tag_Span_E or html_builder_front.last_element == 'text'
      html_builder_front.merge(frontAnswer)
    end
  

    @front_html = html_builder_front.div_e.lf.build
    @back_html = html_builder_back.div_e.lf.build
  end


  private

  # build the tags html. <span>tag1</span>&nbsp;<span>tag2</span>...
  def build_tags(card)
    first = true
    tags_html = HtmlBuilder.new
    @tag_helper.find_multi(card)
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
      highlighted = @highlighter.highlight_all(to_html_raw(element))
      
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
    .gsub(/`([a-zA-Z_ ]+(\(\w*(?: \w*)*(?:, \w*(?: \w*)*)*\))?)`/, '<code>\1</code>')
  end

  # escape angles, and spaces
  def to_html_nbsp(string)
    return to_html_raw(string)
    .gsub('  ', HtmlBuilder::ESP * 2)
    .gsub(HtmlBuilder::ESP + ' ', HtmlBuilder::ESP * 2)
    .gsub("\n", HtmlBuilder::BR)
  end

end
