class Presentation < ActiveRecord::Base
  mount_uploader :video, VideoUploader
  mount_uploader :background, BackgroundUploader

  background_replacement :video, :background
end
