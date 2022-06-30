# Summary
This is the project page for the HVA RTL inpainting assignment. The goal of the assignment was to detect subtitles and logos in a thumbnail, remove them and paint the removed area in. The resulting image must be generated quickly with almost no signs of tempering. Currently the project only supports subtitle inpainting, but with a little bit more training it should also be possible to remove logos.

The way we made the pipeline is as follows:
- Dectect the position of subtitles with YOLOv5x.
- Use the positions to create a mask (black being ignored and white that is going to be cut out).
- Use LaMa to paint the masked area in.

![image](https://user-images.githubusercontent.com/39794751/171628172-a8de46ff-2e0b-4f8e-b55a-39c4bf22460e.png)

Processing an image through this pipeline takes ~2-5 seconds. 

# Models

## YOLOv5x
We used [YOLOv5x](https://github.com/ultralytics/yolov5) for the text detection. This was trained on ~550 Videoland thumbnails that we labeled ourselves.

### How does YOLO work?
YOLO means You Only Look Once. When you feed data to a network it will break it up into a grid in the convolutional layer. Here it will check every grid piece and check if there is an object that it knows in that piece. If so it remembers it and it proceeds. When it look at all the positions it has a lot of intersecting bounding boxes for the same object. To fix this it wil use the an formula to get the best bounding box (intersection over union = intersect area/union area).

## Mask generating
After YOLO predicts where the text is located on an image, our code will make a mask that highlights the text on that picture. YOLO will return coordinates of where the text is and our system will create a new picture that has a black background and white rectangles over those coordinates. This mask can be used by LaMa to highlight which parts should be removed and inpainted. 

## Lama
We used [LaMa](https://github.com/saic-mdal/lama) for the image inpainting. We've chosen a pretrained LaMa model (big-lama) that can be found [here](https://disk.yandex.ru/d/EgqaSnLohjuzAg). This is a collection of the CelebA-HQ and Places datasets.

### How does LaMa work?
The LaMa network needs two kinds of input, namely an image and a mask that indicates which part of the image needs to be painted in. Now lets seperate the inpaiting network in steps:
1. The network downscales the image so that the network has less pixels to work with. This helps with the efficiency of the network. But don't worry the LaMa technique will make sure the quality of the image will be the same as a high resolution image.
2. Most inpainting networks use normal CNN's to compress the image and safe only relevant information like the shape, color and overall style, but not precise details. With this information the model reconstructs the image. The only problem with CNN's is that we use it on downscaled images (low quality images), so when we upscale we will hurt the quality of the image. To prevent this from happening, LaMa uses a Fast Fourier Convolutional Residual Block (FFC) instead of a Convolutional Neural Network (CNN).
3. A Fast Fourier Convolutional Residual Block (FFC) works as follows: It uses both spatial and frequency domains so that it does not need to go back to the early layers to understand the context of the image. The layers will work with CNN in the spatial domain to regonize local feautures (details in the image) and use FFC in the frequency domain to regonize global features (big parts of the image). The FFC transforms your image into frequencies where every pixel represents a frequency. The frequencies display the scales in a images and the size of certain objects, but we still don't know anything about the details. The spatial domain will take care of this using CNN's on this new FFC image, which alows us to work with the whole image on each step of the CNN progress. This way it has a way better understanding of the global context of the image even in early stages, which lowers the computational cost. 
4. Both local and global information are saved and sent to the next layer which will repeat this steps. The final image can be upscaled back since we use frequencies instead of colors and frequencies will be the same whatever the size of the image.

# How to use
## Installation
***IMPORTANT!***  
This project currently only supports Python 3.8.x on Linux.

Clone the repo: `git clone https://github.com/ZepaMK/RTL-Inpainting.git`  

Create a virtual environment and install all the dependencies:
```bash
cd RTL-Inpainting

python3.8 -m venv venv/
source venv/bin/activate

pip install -r requirements.txt
```

## Running the project
Our project can be used in 2 different ways. The first way is to place an input image in the `input` folder, run the project by calling `run.sh`, and receive the output image.  
The second way is to place an input image in the `input` folder, run the project by calling `run_display.sh`, and receive an output which includes images of each step of the process (located in the `steps` folder). This provides an overview of what exactly is happening.

## Cleaning up
To run the project again all folders used to store images have to be cleared, otherwise images of previous runs get used. To clear all image folders simply call `cleanup.sh`. This removes all images except those in the input folder.  
To remove all images including those in the input folder, call the cleanup script with the `-a` argument (`cleanup.sh -a`).

## Training YoloV5
To train YoloV5 you need a dataset with labeled images in the Yolo format. For image labeling we used [CVAT](https://github.com/openvinotoolkit/cvat). Put your labeled images in a folder (we recommend `YoloV5/dataset`). To start training enter the following commands:
```
cd YoloV5/yolov5

python3 train.py --batch 16 --epochs 1000 --data your_dataset_folder/yaml_file.yaml --weights yolov5x.pt
```
We used a batch size of 16 and 1000 epochs on the yolov5x model. For a more comprehensive explanation of YoloV5 checkout their [Github page](https://github.com/ultralytics/yolov5).

# References

- https://github.com/saic-mdal/lama
- https://www.louisbouchard.ai/lama/
- https://github.com/ultralytics/yolov5
