module Assets
  module Normalizer
    def self.included(base)
      base.send :before_save, :normalize_filename
    end

    private

    def normalize_filename
      each_attachment do |name, attachment|
        attachment.instance_write(
          :file_name,
          Assets::Filename.normalize(attachment.instance_read(:file_name))
        )
      end
    end
  end

end