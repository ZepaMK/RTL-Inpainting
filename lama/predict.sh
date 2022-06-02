export TORCH_HOME=$(pwd) && export PYTHONPATH=.

python3 bin/predict.py model.path=$(pwd)/big-lama indir=$(pwd)/rtl_images outdir=$(pwd)/output