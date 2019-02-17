#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# database.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 10:29:48


import psycopg2
from ims24.configuration.environments import (
    IMS_DB_NAME,
    IMS_HOSTNAME,
    IMS_PASSWORD,
    IMS_USERNAME,
    IMS_PORT,
)
from sqlalchemy import create_engine


def getconn():
    """
    generate pool connection with database
    """

    engine = create_engine(
        f"postgresql://{IMS_USERNAME}:{IMS_PASSWORD}@{IMS_HOSTNAME}:{IMS_PORT}/{IMS_DB_NAME}",
        pool_size=20,
        max_overflow=0,
    )

    return engine

