#!/usr/bin/env ruby

require './lib/tag_helper'
require './lib/html_helper'
require './lib/reviewer'
require './lib/source_reader'

require 'logger'
require 'CSV'


class MainClass

  $logger = Logger.new(STDOUT)


  $logger.formatter = proc do |severity, datetime, progname, msg|
    # subscript 3 for eclipse/commandline, 4 for sublime 2
    line = caller[3]
    source = line[line.rindex('/', -1)+1 .. -1]
    "#{severity} #{source} - #{msg}\n"
  end


  @@untagged_count = 0


  # Initialize output file name.
  def initialize(opts={})
    @reviewer = Reviewer.new

    hash = {
      # :source_file => '/Users/royce/Dropbox/Documents/Reviewer/mean/Mean-NPM.txt'
      :source_file => '/Users/royce/Dropbox/Documents/Reviewer/@test.txt'
      # :source_file => '/Users/royce/Dropbox/Documents/Reviewer/design/UML.txt'
      # :source_file => '/Users/royce/Dropbox/Documents/Reviewer/design/test.txt'
    }.merge(opts);

    @@filepath = hash[:source_file]

    $logger.info "File Path: #@@filepath"
    @@filepath = Dir.pwd + File::SEPARATOR + @@filepath unless @@filepath.start_with?(File::SEPARATOR)

    today = Time.new

    source_filename = @@filepath[@@filepath.rindex('/') + 1 .. @@filepath.rindex('.')-1]
    simple_name = source_filename

    @@outputFilename = '/Users/royce/Desktop/Anki Generated Sources/%s %s%s%s_%s%s.tsv' %
    [simple_name,
      today.year % 1000,
      '%02d' % today.month,
      '%02d' % today.day,
      '%02d' % today.hour,
      '%02d' % today.min]
  end

  def execute
    $logger.info 'Program Start. Unit Test: %s' % $unit_test 
    return if $unit_test 

    File.open(@@filepath, 'r') do |file|
      CSV.open(@@outputFilename, 'w', {:col_sep => "\t"}) do |csv|

        SourceReader.new(file).each_card do|tags, front, back|
            write_card(csv, front, back, tags)
        end

        @reviewer.print_sellout
        @reviewer.print_duplicate
        @reviewer.print_card_count
        @reviewer.show_multi

        puts('', @@outputFilename[@@outputFilename.rindex('/') + 1..@@outputFilename.index('.') - 1], '')
      end
    end
  end

  def write_card(csv, front, back, tags)

    tag_helper = TagHelper.new(tags)
    tag_helper.find_multi(back)

    back.pop if back[-1] == ''

    shown_tags = tag_helper.visible_tags
    @reviewer.count_sentence(tag_helper, front, back)

    html_helper = HtmlHelper.new(tag_helper, front, back)
        
    @reviewer.detect_sellouts(front, back) unless tag_helper.is_front_only?

    lst = [html_helper.front_html, html_helper.back_html]

    if tag_helper.untagged?
      lst.push 'untagged'
    else
      lst.push tags.join(',')
    end

    if $logger.debug?
      $logger.debug("Front: \n" + lst[0] + "\n\n")
      $logger.debug("Back: \n" + lst[1] + "\n\n")
      # @@logger.debug("Tag: \n" + lst[2] + "\n\n")
    end

    @reviewer.addFrontCard(tags, front)

    csv << lst
  end

end


main = MainClass.new
# main.test
main.execute
