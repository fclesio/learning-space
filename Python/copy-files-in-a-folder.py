import os
import shutil

toDirectory = "/data/planes"
fromDirectory = "/data/AF447"


for root, dirs, files in os.walk(fromDirectory):  # replace the . with your starting directory
   for file in files:
      path_file = os.path.join(root,file)
      shutil.copy2(path_file,toDirectory) # change you destination dir

