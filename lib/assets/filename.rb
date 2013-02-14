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
      File.basename(@name, File.extname(@name)).parameterize
    end

    def ext_name
      File.extname(@name).downcase 
    end
  end

end