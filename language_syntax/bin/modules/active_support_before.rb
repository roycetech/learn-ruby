require 'active_support/concern'

module ImageUtils
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def clean_up; end
  end

end

module ImageProcessing
  
  extend ActiveSupport::Concern
  
  include ImageUtils
  
  def self.included(base)
    base.clean_up
  end

end

class Image
  include ImageProcessing
end

