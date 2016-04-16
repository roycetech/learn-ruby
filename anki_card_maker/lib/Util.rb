# common.rb

require_relative 'HtmlUtilRuby.rb'

include HtmlUtilRuby

module Util


    COLOR_COMMENT = '#417E60'
    COLOR_CLASSVAR = '#426F9C'    

    def to_html(array)        
        str_builder = array.inject('') do |result, element|
          result += "<br />\n" unless result.empty?
          result += to_html_raw(element)
        end
        
        return (
%Q(<div style="text-align: left;">
%s
</div>\n) % str_builder)
    end

    def to_code_html(array)
        
        str_builder = array.inject('') do |result, element|
            result += "\n" unless result.empty?
        
            highlighted = HtmlUtilRuby::highlight_all(to_html_raw(element))
            if result.end_with? "</span>\n" and highlighted.start_with? "<span"
                result += '<br />' + highlighted
            else
                result += highlighted
            end
        end

        if str_builder.include? "<br />"
            return_value =
%Q(<div style="text-align: left;">
<pre><code>
%s
</code></pre>
</div>\n) % str_builder
        else 
            return_value = 
%Q(<div style="text-align: left;">
<pre>%s</pre>
</div>\n) % str_builder
        end

        return return_value
    end


    def to_figure_html(array)
        
        str_builder = array.inject('') do |result, element|
            result += "\n" unless result.empty?        
            result += to_html_raw(element)
        end

        return_value = 
%Q(<div style="text-align: left;">
<pre style="line-height: 70%%">
%s
</pre>
</div>\n) % str_builder

        return return_value
    end


    def to_html_raw(string)
        return string
            .gsub('<', '&lt;')
            .gsub('>', '&gt;')
    end

    def to_html_rawbr(string)
        return string
            .gsub('<', '&lt;')
            .gsub('>', '&gt;')
            .gsub("\n", '<br />')
    end

    def to_html_nbsp(string)
        return string
            .gsub('<', '&lt;')
            .gsub('>', '&gt;')
            .gsub('  ', '&nbsp;&nbsp;')
            .gsub('&nbsp; ', '&nbsp;&nbsp;')
            .gsub("\n", '<br />')
    end

    def to_html_li(array)
        return_value = ""
        array.each do |element|
            return_value += "<li>%s</li>\n" % HtmlUtilRuby::highlight_comment(to_html_nbsp(element))
        end
        return return_value
    end


    def from_html(string)
        return string.replace('&nbsp;', ' ') \
            .replace('&gt;', '>') \
            .replace('&lt;', '<') \
            .replace('<br/>', "\n") \
            .replace(%Q(<div style="text-align: left;">), '') \
            .replace('</div>', '')
    end



    def Util.array_to_string(array)

    template = <<EOL    
<small style="background-color: #5BC0DE; color: white; border-radius: 5px; padding: 5px;">%s</small>
EOL

        return array.inject('') do |result, element|
            unless result.empty?
                result += '<span>&nbsp;</span>'
            end

            unless ['FB Only', 'BF Only', 'Syntax'].include? element
                result += template % element
            end
            result
        end
    end

end