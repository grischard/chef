class Chef
  class Util
    class EditedFile
      def initialize(file, block)
        @file = file
        @block = block
      end

      def kind_of?(klass)
        klass == String || super
      end

      def to_s
        ::File.new(@file).collect do |line|
          line = @block.call(line)
        end.join("")
      end
    end
  end

  class Recipe
    def edit_file(file, &block)
      Chef::Util::EditedFile.new(file, block)
    end
  end
end
