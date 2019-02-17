#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# database.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 10:29:48

import sqlalchemy.pool as pool
import psycopg2


def getconn():
    c = psycopg2.connect(username="ed", host="127.0.0.1", dbname="test")
    return c


mypool = pool.QueuePool(getconn, max_overflow=10, pool_size=5)
