#!/bin/bash

input_dir=$(pwd)/imgs
output_dir=$(pwd)/output
mask=$(pwd)/input_mask
yolo_mask=$(pwd)/YoloV5/yolov5/runs/detect/exp
yolo_txt=$(pwd)/YoloV5/yolov5/runs/detect/exp/labels
display_dir=$(pwd)/steps

while getopts ":a" option; do
   case $option in
      a)
         rm $input_dir/*.png
   esac
done

rm $mask/*.png
rm $yolo_mask/*.png
rm $yolo_txt/*.txt
rm $display_dir/*.png
rm $output_dir/*.png