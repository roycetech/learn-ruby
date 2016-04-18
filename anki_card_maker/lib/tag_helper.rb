class TagHelper

    HIDDEN_ = %w(FB\ Only BF Only Syntax Code(Front))
    FRONT_ONLY = %w[FB\ Only Enum Practical Bool Code Abbr Syntax EnumU EnumO]
    
    def initialize(tags, back)
        @tags = tags
        @visible_tags = @tags.select do |tag|
           !HIDDEN.include? tag
        end

        @front_only = @tags.select do |tag| 
            FRONT_ONLY.include? tag 
        end.size > 0

        if @tags.include? 'EnumU' or @tags.include? 'EnumO'
          multi_tag = 'Multi:%s' % back.size
          if !@tags.include? multi_tag
            @tags.push(multi_tag)
          end
        end
    end

    def is_front_only
        @front_only
    end

    def visible_tags
        @visible_tags        
    end

    def has_enum

    end

end