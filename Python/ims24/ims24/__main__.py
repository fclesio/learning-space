#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# __main__.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 10:13:23


import time

# import module.extraction as extraction
# import module.transform as transform
# import module.load as load
# import module.visualize as visualize
from ims24 import logger


def main():
    """
    Main loop that extract information from web,
    transform to csv and save on a database using 
    sqlalchemy.
    The visualize() func is to plot some charts
    """
    logger.info("Start ETL ...")
    start_time = time.time()
    # extraction.main()
    # transform.main()
    # load.main()
    # visualize()
    logger.info("End ETL ...")
    elapsed_time = time.time() - start_time
    logger.info("Elapsed Time: %s", elapsed_time)


if __name__ == "__main__":
    main()

