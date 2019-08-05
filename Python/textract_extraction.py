import boto3
import numpy as np
import time
import json
import os
import pandas as pd

name = 'Flavio C.'
root_dir = '/document/'
file_name = 'augmented-data.png'

# Get all files in directory
meine_id_kartes = os.listdir(root_dir)

# get the results
client = boto3.client(
    service_name='textract',
    region_name='eu-west-1',
    endpoint_url='https://textract.eu-west-1.amazonaws.com',
)

meine_id_karte_card_info = []

# For every card get all info
for meine_id_karte in meine_id_kartes:
    time.sleep(5)

    with open(root_dir + meine_id_karte, 'rb') as file:
        img_test = file.read()
        bytes_test = bytearray(img_test)
        print('Image loaded', root_dir + meine_id_karte)

    try:
        # Process using image bytes
        response = client.analyze_document(Document={'Bytes': bytes_test}, FeatureTypes=['FORMS'])

        # Get the text blocks
        blocks = response['Blocks']

        meine_id_karte_text = []

        for i in blocks:
            i = json.dumps(i)
            i = json.loads(i)
            try:
                meine_id_karte_text.append(i['Text'])
            except:
                pass

        meine_id_karte_card_info.append((meine_id_karte, meine_id_karte_text))
    except:
        pass

df_legible = pd.DataFrame(meine_id_karte_card_info)
df_legible.to_csv('normal-karte.csv')
print(df_legible)
