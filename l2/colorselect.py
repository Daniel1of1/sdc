import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import sys

threshold = int(sys.argv[1])

# Read in the image
image = mpimg.imread('test.jpg')

# Grab the x and y size and make a copy of the image
ysize = image.shape[0]
xsize = image.shape[1]
color_select = np.copy(image)

# Define color selection criteria
###### MODIFY THESE VARIABLES TO MAKE YOUR COLOR SELECTION
red_threshold = threshold
green_threshold = threshold
blue_threshold = threshold
######

rgb_threshold = [red_threshold, green_threshold, blue_threshold]

# Do a boolean or with the "|" character to identify
# pixels below the thresholds
thresholds = (image[:,:,0] < rgb_threshold[0]) \
            | (image[:,:,1] < rgb_threshold[1]) \
            | (image[:,:,2] < rgb_threshold[2])
color_select[thresholds] = [0,0,0]

# Uncomment the following code if you are running the code locally and wish to save the image
mpimg.imsave("test-after.jpg", color_select)

