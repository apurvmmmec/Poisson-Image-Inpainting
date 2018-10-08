# Poisson Image Inpainting
In this repo, I provide code for seamlessly blending patches of image from source image into destination image 
using Poisson Image Editing Techniques. I also demonstrate techniques to achieve nice effects like changing color of 
selected regions of image, also called as color Pop Effect, seamless tiling in images, inserting or removing local 
illumination effects and texture flattening.

# Seamless Cloning
I have taken an example of blending my eye on my palm. We firstof all select the left eye mask through roipoly tool and then tell in code, the position at which we want to paste this on target image which is palm image in this case. When the mask region is blended with the target image, source image act as guiding vector for all pixels inside the mask. The pixels inside mask that lie on boundary get the value of target.
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/eyeInHand.png)


![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/iLoveUCL.png)

![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/dolphinInTajmahal.png)
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/sunflower.png)
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/livingRoom.png)
