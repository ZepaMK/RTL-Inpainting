#!/bin/bash

start_dir=$(pwd)
yolo_dir=$(pwd)/YoloV5/yolov5
lama_dir=$(pwd)/lama
input_dir=$(pwd)/imgs
output_dir=$(pwd)/output

cd $yolo_dir
python3 detect.py --weights runs/train/exp10/weights/best.pt --source $input_dir --hide-labels --hide-conf --exist-ok --save-txt

cd $start_dir
python3 mask.py $input_dir

cd $lama_dir
export TORCH_HOME=$(pwd) && export PYTHONPATH=.
python3 bin/predict.py model.path=$(pwd)/big-lama indir=$input_dir outdir=$output_dir