# Poisson Image Inpainting
In this repo, I provide code for seamlessly blending patches of image from source image into destination image 
using Poisson Image Editing Techniques. I also demonstrate techniques to achieve nice effects like changing color of 
selected regions of image, also called as color Pop Effect, seamless tiling in images, inserting or removing local 
illumination effects and texture flattening.

In Image Inpainting, The idea is to reduce the color mismatch between the source and target when we want to bring a region of image from a source image to a region in target image for seamless look. Let us call the known function in target image as f* and the region of target image in which compositing is being done as Ω. The unknown function in Ω is called f and the boundary of Ω is dΩ. We want to solve this problem in gradient domain than working simply in intensity domain. We want the gradient of the composite inside Ω to look as much as possible like the gradient of source image, S. Also, the composite must match the target image on the boundary of Ω. So mathematically


# Seamless Cloning
I have taken an example of blending my eye on my palm. We firstof all select the left eye mask through roipoly tool and then tell in code, the position at which we want to paste this on target image which is palm image in this case. When the mask region is blended with the target image, source image act as guiding vector for all pixels inside the mask. The pixels inside mask that lie on boundary get the value of target.
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/eyeInHand.png)

# Blending with Gradient Mixing
The difference between seamless blending and gradient mixing is that in seamless blending, the gradient of target image does not appear inside the region omega except boundaries of omega. But there are cases when we want to paste a region of semi- transparent image or image with holes on top of a textured background and don’t want to lose the details of background in the region of holes. In such case, we use the technique of mixed gradients where the guidance field at any pixel (x,y) is chosen not necessarily from the Laplacian of source but also from target image depending upon which gradient is stronger at that point. One thing which we need to be taken care while using this approach is that region of details in target image should only lie in holes of source image, or else if high gradients of both source and target are present at some place, detail of either of them will be lost.
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/iLoveUCL.png)

# Cool Effects achieved using Poisson Image Blending

# Dolphin in the pool infront of Taj Mahal
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/dolphinInTajmahal.png)

# Color Pop Effect, making everything monochrome except the Sunflower
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/sunflower.png)

# Painting the wall of Living Room
![alt tag](https://github.com/apurvmmmec/Poisson-Image-Inpainting/blob/master/resources/livingRoom.png)


