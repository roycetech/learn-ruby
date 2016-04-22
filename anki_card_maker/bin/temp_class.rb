require 'logger'

class TempClass


  $logger = Logger.new(STDOUT)


  $logger.formatter = proc do |severity, datetime, progname, msg|
    # subscript 3 for eclipse/commandline, 4 for sublime 2
    line = caller[3]
    source = line[line.rindex('/', -1)+1 .. -1]
    "#{severity} #{source} - #{msg}\n"
  end


  def main
    
    filepath = '/Users/royce/Dropbox/Documents/Reviewer/mean/NPM CLI-Commands.txt'

    File.open(filepath, 'r') do |file|
      
      while line = file.gets
        line.chomp!
        unless line == ''
          puts '@Tags: CLI'
          space_index = line.index(' ')
          # $logger.debug('space index: %s' % space_index)
          
          # begin
             puts (line[0..space_index])
          # rescue
          #   puts('ERROR ******' + line)
          #   exit
          # end

          print "\n"
          puts line[space_index+1..-1] + "\n\n\n"
        end

      end
    end
  end

end

TempClass.new.main
