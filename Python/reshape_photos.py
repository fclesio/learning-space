# Remove the previous version of PIL
# pip uninstall pillow

# Install without using any cache in machine's version
# pip install pillow --no-cache-dir

import os               # Deal with operational system
import getopt           # Accept arguments in script
import sys              # Accept commands in bash
from PIL import Image   # to invoke the resize function
import cv2              # Resize the image and save

# opts = Options; args = arguments - Parameters used "d", "w", "h"
opts, args = getopt.getopt(sys.argv[1:], 'd:w:h:')
 
# Set some default values to the needed variables.
#directory = '/Users/flavio.clesio/Downloads/babies/fotos-baby'
directory = ''
width = -1
height = -1
 
# If an argument was passed in, assign it to the correct variable.
for opt, arg in opts:
    if opt == '-d':
        directory = arg
    elif opt == '-w':
        width = int(arg)
    elif opt == '-h':
        height = int(arg)
 
# We have to make sure that all of the arguments were passed.
if width == -1 or height == -1 or directory == '':
    print('Invalid command line arguments. -d [directory] ' \
          '-w [width] -h [height] are required')
 
    # If an argument is missing exit the application.
    exit()

# Iterate through every image given in the directory argument and resize it.
for image in os.listdir(directory):
    print('Resizing image ' + image)
 
    # Open the image file.
    img = Image.open(os.path.join(directory, image)).convert('RGB')
 
    # Resize it.
    img = img.resize((width, height), Image.BILINEAR)
 
    # Save it back to disk.
    #img.save(os.path.join(directory, 'resized-' + image))
    img.save(os.path.join(directory, '' + image))
 
print('Batch processing complete.')