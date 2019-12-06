# Main Source: https://stackoverflow.com/questions/46184239/extract-a-page-from-a-pdf-as-a-jpeg

# Wrapper to convert pdf to images:
# Requirements:
# 1) brew install poppler
# 2) pip install pdf2image

from pdf2image import convert_from_path
import glob
import os
import uuid

file_path = os.path.dirname(os.path.abspath(__file__))
os.chdir(file_path)

for file in glob.glob("*.pdf"):
    source_path = file_path + '/' + file
    print(f'{source_path}')
    pages = convert_from_path(source_path, 10)
    for page in pages:
        page.save(f'{str(uuid.uuid4().hex)}.jpg', 'JPEG')
