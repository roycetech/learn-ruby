require 'logger'
require './lib/Util'  
require 'CSV'  

include Util

class MainClass


  @@logger = Logger.new(STDOUT)
  @@logger.formatter = proc do |severity, datetime, progname, msg|

    # subscript 3 for eclipse, 4 for sublime 2
    line = caller[4]
    source = line[line.rindex('/', -1)+1 .. -1]
    "#{severity} #{source} - #{msg}\n"
  end


=begin
    Initialize output file name.
=end
  def initialize(opts={})
    super()

    hash = {
        # :source_file => '/Users/royce/Dropbox/Documents/Memorize/ruby/Ruby-Syntax.txt'
        :source_file => '/Users/royce/Dropbox/Documents/Memorize/design/UML.txt'
        # :source_file => '/Users/royce/Dropbox/Documents/Memorize/design/test.txt'
    }.merge(opts);

    @@filepath = hash[:source_file]

    @@logger.info "File Path: #@@filepath"
    @@filepath = Dir.pwd + File::SEPARATOR + @@filepath unless @@filepath.start_with?(File::SEPARATOR)
    @@logger.info @@filepath
    
    today = Time.new

    # attr_reader :duplicates

    # @@filepath = '/Users/royce/Dropbox/Documents/Memorize/ruby/test.txt'
    # @@filepath = '/Users/royce/Dropbox/Documents/Memorize/design/UML.txt'

    @all_front = []  # will be used to review if duplicates are valid.
    @all_front_tag_map = {}  # will be used to review if duplicates are valid.
    @all_multi = []  # will be used to review complex cards
    @all_sellout = []  # will be used to review of question that appear in answer

    source_filename = @@filepath[@@filepath.rindex('/') + 1 .. @@filepath.rindex('.')-1]
    simple_name = source_filename

    @@outputFilename = '/Users/royce/Desktop/Anki Generated Sources/%s %s%s%s_%s%s.tsv' %
                     [simple_name,
                             today.year % 1000,
                             '%02d' % today.month,
                             '%02d' % today.day,
                             '%02d' % today.hour,
                             '%02d' % today.min,
                             '.tsv']
  end

def count_sentence(tags, front, back)
    count = 0

    if tags.include? 'Syntax'
        sentence_count = 1  # Consider syntax as a single statement.
    else

        sentence_count = back.inject(0) do |total, element|
            total += element
                .gsub('e.g.', '')
                .gsub('...', '')
                .gsub('..', '').count('.')
        end
    end
    
    is_enum = tags.include?('EnumU') || tags.include?('EnumO')
    if sentence_count > 1 and not is_enum
        multi_tag = 'Multi:%s' % sentence_count
        if not tags.include? multi_tag
            tags.push(multi_tag)
            @all_multi.push(front.join("\n") + '(%d)' % sentence_count) if sentence_count > 1
        end
    end
    if back.length == 0
        return 0
    else 
        return sentence_count == 0 ? 1 : sentence_count
    end
end


=begin
    Detect single word front cards that appears in back card.
=end
def detect_sellouts(front, back)
    
    # @@logger.debug(front)
    # @@logger.debug(back)

    if front.length == 1 
        front_card = front[0].downcase
        if %r(#{Regexp.quote(front_card)}) =~ back.join("\n").downcase
            @all_sellout.push(front[0])
        end
    end
end


def write_card(csv, front, back, tags, p_question_count, p_skipped_count)

    if back[-1] == ''
        back.pop
    end

    if tags.include?'EnumU' or tags.include?'EnumO'
        multi_tag = 'Multi:%s' % back.size
        if !tags.include? multi_tag
            tags.push(multi_tag)
        end
    end

    count_sentence(tags, front, back)

    l_question_count = p_question_count
    l_skipped_count = p_skipped_count

    l_question_count = p_question_count + 1

    answer_only_html = %Q(<span style="font-weight: bold; background-color: #D9534F; color: white; border-radius: 5px; padding: 5px;">Answer Only</span>\n)

    # tags w/o control tags like BF Only, and FB Only
    # real_tags = [tag for tag in tags if tag not in ['FB Only', 'BF Only', 'Syntax']]
    real_tags = tags.select{ |tag| !%w[FB\ Only BF Only Syntax Code(Front)].include? tag}

    if real_tags.empty?
        tag_html = ''
    else
        tag_html = %Q(<div style="text-align: left;">%s</div>\n) % 
            Util::array_to_string(tags)
    end

    front_only_tags = %w[FB\ Only Enum Practical Bool Code Abbr Syntax EnumU EnumO]
    is_front_only = tags.select {|element| front_only_tags.include? element}.size > 0


    @@logger.debug("is_front_only: %s" % is_front_only)
    if not is_front_only
        detect_sellouts(front, back)
    end

    html_front = ""
    html_back = ""

    if is_front_only
        html_back = answer_only_html
    elsif  tags.include? 'BF Only' or tags.include? 'Syntax' or tags.include? 'Code'
        html_front = answer_only_html
    end

    html_front += tag_html
    if  tags.include? 'Code(Front)'
        html_front += Util::to_code_html(front)
    else
        html_front += Util::to_html(front)
    end

    if @@is_unordered_list

        html_back += %Q(
<div style="text-align: left;"><code>
<ul>
%s  
</ul>
</code></div>') % Util::to_html_li(back)

    elsif @@is_ordered_list

        html_back += %Q(
<div style="text-align: left;"><code>
<ol>
%s
</ol>
</code></div>') % Util::to_html_li(back)
    
    elsif tags.include? 'Syntax' or tags.include? 'Code'
         html_back += Util::to_code_html(back)
    elsif  tags.include? 'Figure'
        html_back += Util::to_figure_html(back)
    else 
        html_back += Util::to_html(back)
    end

    lst = [ html_front, html_back ]

#     if is_front_only
#         if @@is_unordered_list
#             lst = [tag_html + Util::to_html(front), answer_only_html + 
#                 %Q(<div style="text-align: left;"><code>
# <ul>) + Util::to_html_li(back) + '</ul></code></div>']
#         elsif @@is_ordered_list
#             lst = [tag_html + Util::to_html(front), answer_only_html + 
#                 %Q(<div style="text-align: left; font-family: 'Courier New';">
# <ol>) + Util::to_html_li(back) + '</ol></div>']
#         elsif tags.include? 'Syntax' or tags.include? 'Code'
#             lst = [tag_html + Util::to_html(front), answer_only_html +
#              Util::to_code_html(back)]
#         else
#             lst = [tag_html + Util::to_html(front), answer_only_html + 
#                 Util::to_html(back)]
#         end
#     elsif  tags.include? 'BF Only'
#         lst = [answer_only_html + Util::to_html(front), tag_html + 
#             Util::to_html(back)]
#     elsif  tags.include? 'Code(Front)'
#         lst = [tag_html + Util::to_code_html(front),  Util::to_html(back)]
#     elsif  tags.include? 'Figure'
#         lst = [tag_html + Util::to_html(front),  Util::to_figure_html(back)]
#     else
#         lst = [tag_html + Util::to_html(front),  Util::to_html(back)]
#     end

    if real_tags.empty?
        lst.push 'untagged'
        @@untagged_count += 1
    else
        lst.push tags.join(',')
    end

    # puts("Front: \n" + lst[0] + "\n\n")
    # puts("Back: \n" + lst[1] + "\n\n")
    # puts("Tag: \n" + lst[2] + "\n\n")


     front_key = front.join("\n") + tags.join(',')
    @all_front.push(front_key)
    @front_tag_map[front_key] = front.join("\n")

   csv << lst
       
    return l_question_count, l_skipped_count
end                               
                             
def execute

  @@logger.info "Program Start."
                             

    File.open(@@filepath, 'r') do |f|
    CSV.open(@@outputFilename, 'w', { :col_sep => "\t" }) do |csv|

    create_module = true
    space_counter = 0
    is_question = true

    @@is_unordered_list = false  # Marks if tagged as EnumU, will use <ol> or <ul> HTML tags.
    @@is_ordered_list = false  # Marks if tagged as EnumO, will use <ol> HTML tag.

    front, back, tags = [[], [], []]
    front_count, ignored_count, @@untagged_count = 0, 0, 0

    card_began = false  # Marks the start of the first card.

    while line = f.gets

        line.rstrip!

        unless card_began
            if line[0, 1] == '#' or line.strip.empty?
                next
            else
                card_began = true
            end
        end

        if line == ''
            space_counter += 1
        end

        if space_counter >= 2
            is_question = true
        elsif space_counter == 1 and is_question
            is_question = false
            space_counter = 0
        end

        if is_question

            if space_counter >= 2  # write to file

                front_count, ignored_count = write_card(csv, front, back, tags, front_count, ignored_count)

                # reset variables
                space_counter = 0
                @@is_unordered_list = false
                @@is_ordered_list = false

                front, back, tags = [], [], []
            else

                if line[0, 7] == '@Tags: '
                    tags = line[7..-1].split(',').collect{ |element| element.strip }
                    @@is_unordered_list = tags.include? 'EnumU'
                    @@is_ordered_list =  tags.include? 'EnumO'
                elsif tags.include? 'Abbr'
                    front.push(line + ' abbreviation')
                else
                    front.push(line)
                end
            end

        else

            if not line.empty? or not back.empty?

                back.push(line)

                if line != ''
                    space_counter = 0
                end
            end

        end
    end
    
    front_count, ignored_count = write_card(csv, front, back, tags, front_count, ignored_count)

    puts("Total questions: %s" % front_count)
    # puts("Skipped questions: %s" % ignored_count)
    # puts("Output File: %s\n\n" % @@outputFilename)    
    puts("Sellout: %s\n" % @all_sellout.to_s)    
    puts("Potential Duplicates: %s\n" % @all_front.select{|e| @all_front.count(e) > 1}.uniq.to_s)
    
    @all_multi.sort! {
        |a, b|        
         a[/\((\d*)\)/,1].to_i <=> b[/\((\d*)\)/,1].to_i
    }

    puts("Multi Tags: %s\n\n" % @all_multi.to_s)
    puts(@@outputFilename[@@outputFilename.rindex('/') + 1 .. @@outputFilename.index('.') - 1])
    puts
    end
end
end

def duplicates
    @all_front.select{|e| @all_front.count(e) > 1}.uniq
end

end


main = MainClass.new
# main.test
main.execute






