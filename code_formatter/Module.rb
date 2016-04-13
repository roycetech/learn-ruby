module MyApp

  def self.hello
    puts 'Hello'
    # world
  end

  def world
    puts 'World'
  end
  
end

module MyUtil

    class ObjUtil
        def self.nvl(obj, when_null)
            return obj.nil? ? when_null : obj
        end
    end

end

class MainClassWithInclude
    
    include MyUtil

    def start
        local = nil
        # local = 'I It is set!'

        puts ObjUtil.nvl(local, 'I Local unset!')
    end
end

class MainClass
    
    def start

        # local = nil
        local = 'It is set!'


        puts MyUtil::ObjUtil.nvl(local, 'Local unset!')
    end
end

# main = MainClass.new
# main = MainClassWithInclude.new
# main.start


mod = MyApp.new

mod.hello

