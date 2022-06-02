#!/bin/bash

start_dir=$(pwd)
yolo_dir=$(pwd)/YoloV5/yolov5
lama_dir=$(pwd)/lama
input_dir=$(pwd)/imgs
output_dir=$(pwd)/output
mask=$(pwd)/input_mask
yolo_mask=$(pwd)/YoloV5/yolov5/runs/detect/exp
display_dir=$(pwd)/steps

# Copy input files to display dir and give suffix _a
#cp -a $input_dir/. $display_dir
#cd $display_dir
#for file in *.png; do mv "$file" "${file%.png}_a.png"; done


cd $yolo_dir
python3 detect.py --weights runs/train/exp10/weights/best.pt --source $input_dir --hide-labels --hide-conf --exist-ok --save-txt

# Copy masks
cp -a $input_dir/. $mask
cd $start_dir
python3 mask.py $input_dir $mask
cp -a $mask/. $display_dir

# Rename yolo files and copy to display dir
cd $yolo_mask
for file in *.png; do mv "$file" "${file%.png}_b.png"; done
cp -a *.png $display_dir

cd $lama_dir
export TORCH_HOME=$(pwd) && export PYTHONPATH=.
python3 bin/predict.py model.path=$(pwd)/big-lama indir=$mask outdir=$output_dir

# Rename output and copy to display dir
cd $output_dir
for file in *.png; do mv "$file" "${file%.png}s.png"; done
cp -a $output_dir/. $display_dir