## Summary
This is the project page for the HVA RTL inpainting assignment. The goal of the assignment was to detect subtitles and logos in a thumbnail, remove them and paint the removed area in. The resulting image must be generated quickly with almost no signs of tempering. Currently the project only supports subtitle inpainting, but with a little bit more training it should also be possible to remove logos.

The way we made the pipeline is as follows:
- Dectect the position of subtitles with YOLOv5x.
- Use the positions to create a mask (black being ignored and white that is going to be cut out).
- Use LaMa to paint the masked area in.

![image](https://user-images.githubusercontent.com/39794751/171628172-a8de46ff-2e0b-4f8e-b55a-39c4bf22460e.png)

This pipeline is finished in ~5 seconds. 


# How to use
....

## Models
We used [YOLOv5x](https://github.com/ultralytics/yolov5) for the text detection. This was trained on 200 RTL thumbnail that we labeled our self. This will be between the 500 and 700 when we receive our labeled images from rtl.

We used [LaMa](https://github.com/saic-mdal/lama) for the image inpainting. We've chosen a pretrained model of laMas that can be found [here](https://disk.yandex.ru/d/EgqaSnLohjuzAg). This is a collection of the celeb, places and other miscellaneous datasets.
