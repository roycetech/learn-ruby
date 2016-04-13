# common.rb

module Util

    COMMENT_COLOR = '#417E60'


    def nvl2(arg1, when_null, when_not_null)
        if arg1
            when_not_null
        else
            when_null
        end
    end


    def nvl(arg1, when_null)
        return when_null unless arg1
    end


    def to_html(array)
        
        str_builder = array.inject('') do |result, element|
          # result += "<br />\n" unless result.empty?
          result += "\n" unless result.empty?
          result += to_html_raw(element)
        end
        
        # range = 0...array.length-1
        # range.each do |element|
#         
# 
        # str_builder = ""
        # array.each_with_index do |element, index|
            # str_builder += to_html_raw(element)
            # if index == 
             # + "<br />\n"
        # end

        return (
%Q(<div style="text-align: left; font-family: 'Courier New';">
%s
</div>\n) % str_builder)

    end


    def to_html_raw(string)

        if string.include? '# '
            comment = string[string.index('# ')..-1];
            non_comment = string[0..string.index('# ')-1]
        else
            comment = ''
            non_comment = string
        end

        return_value = non_comment
            .gsub('<', '&lt;')
            .gsub('>', '&gt;')
            # .gsub("\n", "<br />\n")

        unless comment.empty?
            return_value += "<span style='color: %s'>%s</span>" % [COMMENT_COLOR, comment]
        end

        return  return_value
    end


    def to_html_li(array)
        return_value = ""
        array.each do |element|
            return_value += "<li>%s</li>\n" % to_html_raw(element)
        end
        return return_value
    end


    def from_html(string)
        return string.replace('&nbsp;', ' ') \
            .replace('&gt;', '>') \
            .replace('&lt;', '<') \
            .replace('<br/>', "\n") \
            .replace(%Q(<div style="text-align: left;font-family: 'Courier New';">), '') \
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