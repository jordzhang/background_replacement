##介绍
实现视频替换背景，在ActiveRecord中配置视频和背景field,自动生成替换背景的视频。
##使用

```ruby
#Gemfile
gem 'background_replacement', github: 'jordzhang/background_replacement'

#Model
class Video < ActiveRecord::Base
 background_replacment :video_field, :background_field
end
```

##依赖
* FFmpeg
* Opencv
* Carrierwave
