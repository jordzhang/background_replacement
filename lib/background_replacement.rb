module BackgroundReplacement
  extend ActiveSupport::Concern
  included do
  end

  module ClassMethods
    def background_replacement(video, background, options={})

      # TODO after_save ,invoke the "replace_background" method when the video and background are changed.
      after_save BackgroundReplacement.ReplacementCallBacks.new(video, background, options), if: Proc.new{|m| m.send("#{video}_changed?") || m.send("#{background}_changed?")}
      # mod = Module.new
      # include mod
      # mod.class_eval <<-EOF
      #   def replace_background
      #     BackgroundReplacement.replace_background(video, background, options)
      #   end
      # EOF
    end
  end


  class ReplacementCallBacks

    def intialize(video, background, options={})
      @video = video
      @background = background
      @options = options
    end
    def after_save(m)
      if @video.present? && @background.present?
      replacement_version = @options[:replacement_version] || :replacement
      replacement_path = @video.try(replacement_version).try(:current_path)

      if replacement_path.present?
        current_path = @video.current_path
        # split audio to mp3
        audio_path = File.join(File.dirname(current_path), "tmpfile.mp3")
        file = ::FFMPEG::Movie.new(current_path)
        file.transcode(audio_path, "-vn")

        avi_path = File.join(File.dirname(current_path), "tmpfile.avi")
        file.transcode(avi_path, "-an -vcodec libx264")

        ouput_path = File.join(File.dirname(current_path), "replacement_tmp.avi")
        system "chbg.py -i #{avi_path} -b #{background.current_path} -o #{ouput_path}"
        result_path = File.join(File.dirname(current_path), "tmpfile.mp4")

        movie = ::FFMPEG::Movie.new(ouput_path)
        movie.transcode(result_path, "-i #{audio_path} ")

        File.rename result_path, replacement_path
      end
    end
  end
end

ActiveRecord::Base.send :include, BackgroundReplacement
