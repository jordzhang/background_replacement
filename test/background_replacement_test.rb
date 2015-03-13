require 'test_helper'

class BackgroundReplacementTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, BackgroundReplacement
  end

  test "upload video" do
    presentation = Presentation.new
    File.open("1.mp4") do |f|
      presentation.video = f
    end
    u.save!
  end
end
