#!/usr/bin/python
import argparse
import cv2
import numpy as np

parser = argparse.ArgumentParser(description="replace video background")
parser.add_argument("-i", help="input video file")
parser.add_argument("-b", help="replace background image")
parser.add_argument("-o", help="output video file");
args = parser.parse_args()

video_file = args.i
bg_file = args.b
output_file = args.o

if video_file == None or bg_file == None or output_file == None:
  exit(0)

videoCapture = cv2.VideoCapture(video_file)

fps = videoCapture.get(cv2.cv.CV_CAP_PROP_FPS)
size = (int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_WIDTH))
  ,int(videoCapture.get(cv2.cv.CV_CAP_PROP_FRAME_HEIGHT)))

videoWriter = cv2.VideoWriter(output_file, cv2.cv.CV_FOURCC(*"MJPG"), fps, size, True)
success, frame = videoCapture.read()
bg_image = cv2.resize(cv2.imread(bg_file), size)
lower_blue = np.array([100,110,40])
upper_blue = np.array([130,255,255])
enableSmooth = True
smoothRadio = 5
while success:

  hsvImage = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
  mask = cv2.inRange(hsvImage, lower_blue, upper_blue)
  mask = cv2.bitwise_not(mask)

  mask = cv2.dilate(mask, None, iterations=1)
  mask = cv2.erode(mask, None, iterations=3)

  maskImage = cv2.cvtColor(mask, cv2.COLOR_GRAY2BGR)

  frontScene = cv2.bitwise_and(frame, maskImage)
  backScene = cv2.subtract(bg_image, maskImage)

  sceneout = cv2.add(frontScene, backScene)

  if enableSmooth:
    backScene = cv2.subtract(sceneout, maskImage)

    maskImage = cv2.erode(maskImage, None, iterations=smoothRadio+1)
    frontScene = cv2.bitwise_and(sceneout, maskImage)
    sceneout = cv2.GaussianBlur(sceneout,(smoothRadio*2+1,smoothRadio*2+1), 0)
    sceneout = cv2.subtract(sceneout, maskImage)
    sceneout = cv2.add(sceneout, frontScene)

    sceneout = cv2.subtract(sceneout, backScene)
    sceneout = cv2.add(sceneout, backScene)

  videoWriter.write(sceneout)
  # cv2.imshow("Video", sceneout)
  # cv2.waitKey(1000/int(fps))

  success, frame = videoCapture.read()
