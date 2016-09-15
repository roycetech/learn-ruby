require 'active_support/concern'

module ImageUtils
  extend ActiveSupport::Concern
  module ClassMethods
    def clean_up() 
      puts 'Cleanup called'
    end
  end

  def mod1
    1
  end
end

module ImageProcessing
  extend ActiveSupport::Concern
  include ImageUtils


  included do
    clean_up
  end

  def mod2
    puts mod1()

    puts 2
  end
end

class Image
  include ImageProcessing

  def go
    mod2
  end

end

Image.new.go