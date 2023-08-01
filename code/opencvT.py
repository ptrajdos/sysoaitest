import cv2
import numpy as np

if __name__ == '__main__':
 
    image = cv2.imread("./lenna.png", 1)
    # Loading the image
    
    half = cv2.resize(image, (0, 0), fx = 0.1, fy = 0.1)
    bigger = cv2.resize(image, (1050, 1610))
    
    stretch_near = cv2.resize(image, (780, 540),
                interpolation = cv2.INTER_LINEAR)

    print(image.shape)