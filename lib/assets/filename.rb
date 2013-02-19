module Assets

  class Filename
    def self.normalize(name)
      self.new(name).normalize
    end

    def initialize(name)
      @name = name
    end

    def normalize
      "#{file_name}#{ext_name}"
    end

    private

    def file_name
      unless @name.blank?
        File.basename(@name, File.extname(@name)).parameterize
      else
        nil
      end
    end

    def ext_name
      unless @name.blank?
        File.extname(@name).downcase 
      else
        nil
      end
    end
  end

end