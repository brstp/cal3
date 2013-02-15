module Assets
  module Normalizer
    def self.included(base)
      base.send :before_save, :normalize_filename
    end

    private

    def normalize_filename
      each_attachment do |name, attachment|
        unless attachment == "missing.jpg" || attachment == "missing.png"
          attachment.instance_write(
            :file_name,
            Assets::Filename.normalize(attachment.instance_read(:file_name))
          )
        else
          attachment.instance_write(:file_name, nil)
        end
      end
    end
  end

end