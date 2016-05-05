class TagHelper


  HIDDEN = %w(FB\ Only BF\ Only Code(Front))
  FRONT_ONLY = %w[FB\ Only Enum Practical Bool Code Abbr Syntax EnumU EnumO]


  def initialize(tags)
    @tags = tags

    @front_only = @tags.select do |tag|
      FRONT_ONLY.include? tag
    end.size > 0

    @back_only = @tags.include? 'BF Only'
  end

  def self.parse(string)
    return string[7..-1].split(',').collect do |element|
      element.strip
    end
  end

  def find_multi(card)
    if has_enum?
      multi_tag = 'Multi:%s' % card.size
      if !@tags.include? multi_tag
        @tags.push(multi_tag)
      end
    end
  end

  def add(tag)
    @tags.push tag if not @tags.include? tag
  end

  def include?(tag)
    return @tags.include? tag
  end

  def one_sided?
    is_front_only? or is_back_only?
  end

  def is_front_only?
    @front_only
  end

  def is_back_only?
    @back_only
  end

  def command?
    @tags.include? 'Command'
  end

  def visible_tags
    @tags.select do |tag|
      !HIDDEN.include? tag
    end
  end

  def figure?
    @tags.include? 'Figure'
  end

  def code_front?
    @tags.include?'Code(Front)' or @tags.include?'Annotation'
  end

  def ol?
    @tags.include?('EnumO')
  end

  def ul?
    @tags.include?('EnumU')
  end

  def code_back?
    @tags.include?('Syntax') or @tags.include?('Code')
  end

  def untagged?
    return visible_tags.empty?
  end

  def has_enum?
    return (ul? or ol?)
  end

end
