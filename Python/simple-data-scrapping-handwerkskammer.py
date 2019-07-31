#!/usr/bin/env python
# coding: utf-8

import multiprocessing as mp
import numpy as np
import pandas as pd
import requests
import time
from bs4 import BeautifulSoup

zipcodes_list = [
    10119,
    10178,
    10179,
    40225,
    40227,
    40229,
    40231,
    80997,
    80999,
    81247,
    81249,
]


def get_handwerkskammer_zipcode_location(zipcode):
    """
      Based in the zipcode get the address of 
      a Handwerkskammer in Germany.

      Parameters
      ----------
      zipcode : list
          Zipcodes of all germany

      Returns
      -------
      zipcode : int
          Zipcode to be queried
          
      handwerkskammer_name : string
          Name of the Handwerkskammer based in the Zipcode
          
      handwerkskammer_current_address : string
          Complete address of the Handwerkskammer
      """

    BASE_URL = "https://www.handwerkskammer.de/kontakte/zustaendige-handwerkskammer-5620,0,dazustaendig.html?dag=1&plzonr="

    # Get the info about address
    handwerkskammer_current_address = []

    try:
        # Build the URL and extract the HTML
        hanwerkskammer_url = BASE_URL + str(zipcode)
        res = requests.get(hanwerkskammer_url)
        html_page = res.content
        soup = BeautifulSoup(html_page, "html.parser")

        # Get Handwerkskammer Name
        handwerkskammer_info = soup.find(class_="odav-pagetitle")
        handwerkskammer_name = handwerkskammer_info.contents

        # Get only the page element that can contain the address
        for node in soup.find("div", {"class": "col-sm-6"}):
            handwerkskammer_current_address.append(" ".join(node.findAll(text=True)))
    except:
        zipcode = 0
        hanwerkskammer_name = "None"
        handwerkskammer_current_address = "None"

    return (zipcode, handwerkskammer_name, handwerkskammer_current_address[0])


# Empty DF to get info
df_zipcodes = pd.DataFrame()

# Main function with Multiprocessing to fetch all data
def main(df):
    pool = mp.Pool(mp.cpu_count())
    result = pool.map(get_handwerkskammer_zipcode_location, zipcodes_list)
    df = df.append(pd.DataFrame(result))
    return df


# Time tracking
start_time = time.time()

# Call the main wrapper with multiprocessing
df_zipcodes = main(df_zipcodes)

elapsed_time = time.time() - start_time
fetching_time = time.strftime("%H:%M:%S", time.gmtime(elapsed_time))
print(f"Fetching Time: {fetching_time}")

# Small adjustments in the columns
df_zipcodes.columns = ["zipcode", "handwerkskammer", "address"]

# Final result
df_zipcodes
