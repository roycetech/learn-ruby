require 'logger'
require './util/Util'  
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
  def initialize
    super
    
    today = Time.new

    @@filepath = '/Users/royce/Dropbox/Documents/Memorize/ruby/test.txt'
    # @@filepath = '/Users/royce/Dropbox/Documents/Memorize/ruby/Ruby-Syntax.txt'
    
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

def write_card(csv, front, back, tags, p_question_count, p_skipped_count)

    l_question_count = p_question_count
    l_skipped_count = p_skipped_count

        l_question_count = p_question_count + 1

        answer_only_html = %Q(<span style="font-weight: bold; background-color: #D9534F; color: white; border-radius: 5px; padding: 5px;">Answer Only</span>\n)

        if tags.empty?
            tag_html = ''
        else
            tag_html = %Q(<div style="text-align: left;">%s</div>\n) % Util::array_to_string(tags)
        end

        front_only_tags = %w[FB\ Only Enum Practical Bool Code Abbr Syntax EnumU EnumO]
        is_front_only = tags.select {|element| front_only_tags.include? element}.size > 0

        if is_front_only
            if @@is_unordered_list
                lst = [tag_html + Util::to_html(front), answer_only_html + %Q(<div style="text-align: left;"><code>
<ul>) + Util::to_html_li(back) + '</ul></code></div>']
            elsif @@is_ordered_list
                lst = [tag_html + Util::to_html(front), answer_only_html + %Q(<div style="text-align: left; font-family: 'Courier New';">
<ol>) + Util::to_html_li(back) + '</ol></div>']
            elsif tags.include? 'Syntax'
                lst = [tag_html + Util::to_html(front), answer_only_html + Util::to_code_html(back)]
            else
                lst = [tag_html + Util::to_html(front), answer_only_html + Util::to_html(back)]
            end

        elsif  tags.include? 'BF Only'
            lst = [answer_only_html + Util::to_html(front), tag_html + Util::to_html(back)]
        else
            lst = [tag_html + Util::to_html(front),  Util::to_html(back)]
        end

        # tags w/o control tags like BF Only, and FB Only
        # real_tags = [tag for tag in tags if tag not in ['FB Only', 'BF Only', 'Syntax']]
        real_tags = tags.select{ |tag| !%w[FB\ Only BF Only Syntax].include? tag}

        if real_tags.empty?
            lst.push 'untagged'
            @@untagged_count += 1
        else
            lst.push tags.join(',')
        end

        puts("Front: \n" + lst[0] + "\n\n")
        puts("Back: \n" + lst[1] + "\n\n")
        puts("Tag: \n" + lst[2] + "\n\n")
        
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

        line = line.rstrip()

        unless card_began
            if line[0, 1] == '#' or line.strip.empty?
                next
            else
                card_began = true
            end
        end

        if line.strip() == ''
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

                if tags.include? 'EnumU' or tags.include? 'EnumO'
                    multi_tag = 'Multi:%s' % back.size
                    if !tags.include? multi_tag
                        tags.push(multi_tag)
                    end
                end

                if back[-1] == ''
                    back.pop
                end

                front_count, ignored_count = write_card(csv, front, back, tags, front_count, ignored_count)

                # reset variables
                space_counter = 0
                @@is_unordered_list = false
                @@is_ordered_list = false

                front, back, tags = [], [], []
            else

                if line[0, 7] == '@Tags: '
                    tags = line[7..-1].split(',').collect{|element| element.strip}
                    @@is_unordered_list = tags.include? 'EnumU'
                    @@is_ordered_list =  tags.include? 'EnumO'
                elsif tags.include? 'Abbr'
                    front.push(Util::to_html(line.rstrip(' ') + ' abbreviation\n'))                
                else
                    front.push(line)
                end
            end

        else

            if not line.empty? or not back.empty?

                sentence_count = line.sub('e.g.', '').sub('...', '').sub('..', '').count('.')
                if sentence_count > 1
                    multi_tag = 'Multi:%s' % sentence_count
                    if not tags.include? multi_tag
                        tags.push(multi_tag)
                    end
                end

                back.push(line)

                if line != ''
                    space_counter = 0
                end
            end

        end
    end

    front_count, ignored_count = write_card(csv, front, back, tags, front_count, ignored_count)

    puts("Total questions: %s" % front_count)
    puts("Skipped questions: %s" % ignored_count)
    puts("Untagged Count: %s\n\n" % @@untagged_count)
    puts("Output File: %s\n\n" % @@outputFilename)

    puts(@@outputFilename[@@outputFilename.rindex('/') + 1 .. @@outputFilename.index('.') - 1])
    end
end
end
end

main = MainClass.new
main.execute