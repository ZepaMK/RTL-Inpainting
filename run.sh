#!/bin/bash

start_dir=$(pwd)
yolo_dir=$(pwd)/YoloV5/yolov5
lama_dir=$(pwd)/lama
input_dir=$(pwd)/imgs
output_dir=$(pwd)/output

# Run yolo
cd $yolo_dir
python3 detect.py --weights runs/train/exp29/weights/best.pt --source $input_dir --hide-labels --hide-conf --exist-ok --save-txt --nosave

# Generate masks
cd $start_dir
python3 mask.py $input_dir $input_dir

# Run lama
cd $lama_dir
export TORCH_HOME=$(pwd) && export PYTHONPATH=.
python3 bin/predict.py model.path=$(pwd)/big-lama indir=$input_dir outdir=$output_dir