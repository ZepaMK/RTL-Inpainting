# Summary
This is the project page for the HVA RTL inpainting assignment. The goal of the assignment was to detect subtitles and logos in a thumbnail, remove them and paint the removed area in. The resulting image must be generated quickly with almost no signs of tempering. Currently the project only supports subtitle inpainting, but with a little bit more training it should also be possible to remove logos.

The way we made the pipeline is as follows:
- Dectect the position of subtitles with YOLOv5x.
- Use the positions to create a mask (black being ignored and white that is going to be cut out).
- Use LaMa to paint the masked area in.

![image](https://user-images.githubusercontent.com/39794751/171628172-a8de46ff-2e0b-4f8e-b55a-39c4bf22460e.png)

This pipeline is finished in ~2-5 seconds. 

# Models

## YOLOv5x
We used [YOLOv5x](https://github.com/ultralytics/yolov5) for the text detection. This was trained on 200 Videoland thumbnails that we labeled ourselves. This will be between the 500 and 700 when we receive our labeled images from RTL.

## How does YOLO work?
YOLO means You Only Look Once. When you feed data to a network it will break it up into a grid in the convolutional layer. Here it will check every grid piece and check if there is an object that it knows in that piece. If so it remembers it and it proceeds. When it look at all the positions it has a lot of intersecting bounding boxes for the same object. To fix this it wil use the an formula to get the best bounding box (intersection over union = intersect area/union area).

## Lama
We used [LaMa](https://github.com/saic-mdal/lama) for the image inpainting. We've chosen a pretrained LaMa model that can be found [here](https://disk.yandex.ru/d/EgqaSnLohjuzAg). This is a collection of the celeb, places and other miscellaneous datasets.

### How does LaMa work?
De LaMa network needs two kinds of input, namely am image and a mask that indicates which part of the image needs to be painted in. Now lets seperate the inpaiting netwerk in steps:
1. The netwerk downscales the image so that the network has less pixels to work with. This helps with the efficiency of the network. But don't worry the LaMa technique will make sure the quality of the image will be the same as a high resolution image.
2. Most inpainting networks use normal CNN's to compress the image and safe only relevant information like the shape, color and overall style, but not precise details. With this information the model reconstructs the image. The only problem with CNN's is that we use it on downscaled images (low quality images), so when we upscale we will hurt the quality of the image. To prevent this from happening, LaMa uses a Fast Fourier Convolutional Residual Block (FFC) instead of a Convolutional Neural Network (CNN).

# How to use
....


