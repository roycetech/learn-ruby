#!/usr/bin/env ruby

require_relative 'ObjUtil.rb'

module HtmlUtilRuby

    COLOR_COMMENT = '#417E60'
    COLOR_CLASSVAR = '#426F9C'

    KEYWORDS = %w[BEGIN class ensure nil self when
     END def false not super while < > <= >= %
     alias defined for or then yield = !=
     and do if redo true begin else
     in rescue undef break elsif module
     retry unless case end next return until]


    def self.highlight_keyword(string)
        for keyword in KEYWORDS do
            
            comment_index = ObjUtil::nvl(string.index('# '), 10_000)  # Dummy max value.
            keyword_index = ObjUtil::nvl(string.index(keyword), -1)

            if keyword_index <= comment_index && Regexp.new('\b' + keyword + '\b') =~ string            
                string.sub!(Regexp.new(keyword), '<span style="color: #7E0854">' + keyword + '</span>')
            end
        end        
        # string.sub!('</span>', "</span><br />") if string.end_with? '</span>' and not string.start_with? '<span'
    end

    def self.highlight_symbol(string)
        pattern = /\b = \b/
        if pattern =~ string
            string.sub!(pattern, '<span style="color: #7E0854"> = </span>')
        end
    end

    def self.highlight_double_quote(string)
        pattern = %r|("[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*")|
        string.gsub!(pattern, %q(<span style='color: #1324BF'>\1</span>))
    end

    def self.highlight_single_quote(string)
        pattern = %r|('[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*')|
        string.gsub!(pattern, %q(<span style='color: #1324BF'>\1</span>))
    end

    def self.highlight_comment(string)
        pattern = /# .*$/
        if pattern =~ string
            string.sub!(pattern, '<span style="color: #4F8460">' + string[pattern] + '</span>')
        end
        string
    end

    def self.highlight_comment_br(string)
        pattern = /# .*$/
        if pattern =~ string
            string.sub!(pattern, '<span style="color: #4F8460">' + string[pattern] + '</span><br />')
        end
        string
    end


=begin
    Added <br/ > as workaround to quirk of missing new lines.    
=end
    def self.highlight_block_param(string)
        pattern = Regexp.new %Q{\\|[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*\\|}
        if pattern =~ string
            string.sub!(pattern, '<span style="color: #693E3F">' + string[pattern] + '</span>')
        end
    end

=begin
    highlight instance and class variables
=end
    def self.highlight_variable(string)
        pattern = /@[@a-z_A-Z]*\s/
        if pattern =~ string
            string.sub!(pattern, '<span style="color: %s">' %  COLOR_CLASSVAR + string[pattern] + '</span>')
        end
    end

=begin
    Some spaces adjacent to tags need to be converted because it is not honored by
    <pre> tag.
=end
    def self.space_to_nbsp(string)
        
        pattern_between_tag = /> +</
        while pattern_between_tag =~ string            
            lost_spaces = string[pattern_between_tag]
            string.sub!(pattern_between_tag, '>' + ('&nbsp;' * (lost_spaces.length - 2)) + '<')
        end
        
        pattern_before_tag = /^\s+</
        if pattern_before_tag =~ string            
            lost_spaces = string[pattern_before_tag]
            string.sub!(pattern_before_tag, ('&nbsp;' * (lost_spaces.length - 1)) + '<')
        end

    end


    def highlight_all(string)

        highlight_double_quote(string)
        highlight_single_quote(string)
        highlight_keyword(string)
        highlight_symbol(string)
        highlight_comment(string)
        highlight_block_param(string)
        highlight_variable(string)
        space_to_nbsp(string)
        string
    end

end