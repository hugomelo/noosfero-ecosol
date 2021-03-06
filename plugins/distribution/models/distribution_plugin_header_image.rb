class DistributionPluginHeaderImage < ActiveRecord::Base
  set_table_name 'images'

  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :path_prefix => 'public/image_uploads',
                 :resize_to => 'crop: 1040x90',
                 :max_size => 500.kilobytes # remember to update validate message below

  validates_attachment :size => N_("%{fn} of uploaded file was larger than the maximum size of 500.0 KB")

  protected

  # Override image resizing method for adding crop support
  def resize_image(img, size)
    # resize_image take size in a number of formats, we just want
    # Strings in the form of "crop: WxH"
    if (size.is_a?(String) && size =~ /^crop: (\d*)x(\d*)/i) || (size.is_a?(Array) && size.first.is_a?(String) && size.first =~ /^crop: (\d*)x(\d*)/i)
      img.crop_resized!($1.to_i, $2.to_i, Magick::CenterGravity)
      # We need to save the resized image in the same way the
      # orignal does.
      self.temp_path = write_to_temp_file(img.to_blob)
    else
      super # Otherwise let attachment_fu handle it
    end
  end
end
