module BackgroundReplacement
  extend ActiveSupport::Concern
  included do
  end

  module ClassMethods
    def background_replacement(video, background, replacement_version, options={})
      after_save BackgroundReplacement::ReplacementCallBacks.new(video, background, replacement_version, options), if: Proc.new{|m| m.send("#{video}_changed?") || m.send("#{background}_changed?")}
    end
  end


  class ReplacementCallBacks

    def initialize(video, background, replacement_version, options={})
      @video = video
      @background = background
      @options = options
      @replacement_version = replacement_version
    end
    def after_save(m)

      video = m.send("#{@video}")
      background = m.send("#{@background}")
      if video.present? && background.present?
        replacement_path = video.try(@replacement_version).try(:current_path)

        if replacement_path.present?
          current_path = video.current_path
          # split audio to mp3
          audio_path = File.join(File.dirname(current_path), "tmpfile.mp3")
          file = ::FFMPEG::Movie.new(current_path)
          file.transcode(audio_path, "-vn")

          avi_path = File.join(File.dirname(current_path), "tmpfile.avi")
          file.transcode(avi_path, "-an -vcodec libx264")

          ouput_path = File.join(File.dirname(current_path), "replacement_tmp.avi")
          bin_file = File.expand_path('../../bin/chbg.py', __FILE__);
          system "#{bin_file} -i #{avi_path} -b #{background.current_path} -o #{ouput_path}"

          result_path = File.join(File.dirname(current_path), "tmpfile.mp4")

          movie = ::FFMPEG::Movie.new(ouput_path)

          movie.transcode(result_path, ({custom: "-i #{audio_path}"}.merge(@options)))

          File.rename result_path, replacement_path
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, BackgroundReplacement
