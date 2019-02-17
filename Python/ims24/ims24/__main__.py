#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# __main__.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 10:13:23


import time

from ims24.services.extractor import Extractor
from ims24 import logger
from ims24.services.haus import ExtractorHaus


def main():
    """
    Main loop that extract information from web,
    transform to csv and save on a database using 
    sqlalchemy.
    The visualize() func is to plot some charts
    """
    logger.info("Start ETL ...")
    start_time = time.time()
    extractor = Extractor()
    result = extractor.return_data()
    extractor_haus = ExtractorHaus(list_haus=result)

    logger.info("End ETL ...")
    elapsed_time = time.time() - start_time
    logger.info("Elapsed Time: %s", elapsed_time)


if __name__ == "__main__":
    main()

