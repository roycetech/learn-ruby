#!/usr/bin/env ruby

$keywords = %w[BEGIN class ensure nil self when
 END def false not super while
 alias defined for or then yield
 and do if redo true begin else
 in rescue undef break elsif module
 retry unless case end next return until]

def highlight_keyword(string)
    for keyword in $keywords do
        if Regexp.new('\b' + keyword + '\b') =~ string            
            string.sub!(Regexp.new(keyword), '<span style="color: #7E0854">' + keyword + '</span>')
        end
    end
end

def highlight_symbol(string)
    pattern = /\b = \b/
    if pattern =~ string
        string.sub!(pattern, '<span style="color: #7E0854"> = </span>')
    end
end

def highlight_double_quote(string)
    pattern = Regexp.new %Q|"[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*"|
    if pattern =~ string
        string.sub!(pattern, '<span style="color: #1324BF">' + string[pattern] + '</span>')
    end
end

def highlight_single_quote(string)
    pattern = Regexp.new %Q|'[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*'|
    if pattern =~ string
        string.sub!(pattern, '<span style="color: #1324BF">' + string[pattern] + '</span>')
    end
end

def highlight_comment(string)
    pattern = /# .*$/
    if pattern =~ string
        string.sub!(pattern, '<span style="color: #4F8460">' + string[pattern] + '</span>')
    end
end

def highlight_block_param(string)
    pattern = Regexp.new %Q{\\|[^"\\\r\n]*(?:\\.[^"\\\r\n]*)*\\|}
    if pattern =~ string
        string.sub!(pattern, '<span style="color: #693E3F">' + string[pattern] + '</span>')
    end
end


def highlight_all(string)

    highlight_double_quote(string)
    highlight_single_quote(string)
    highlight_keyword(string)
    highlight_symbol(string)
    highlight_comment(string)
    highlight_block_param(string)

    puts string
end

source = "source.txt"

File.open(source, 'r') do |file|

    puts '<pre>'
    while line = file.gets
        highlight_all(line)
    end
    puts '</pre>'

end
