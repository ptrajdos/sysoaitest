from skimage import data


if __name__ == '__main__':
 
    camera = data.camera()
    
    # An image with 512 rows
    # and 512 columns
    type(camera)
    
    print(camera.shape)