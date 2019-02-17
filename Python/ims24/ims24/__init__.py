#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# __init__.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 10:13:12


import logging
from logging.handlers import RotatingFileHandler
import os, sys
from cmreslogging.handlers import CMRESHandler
from pathlib import Path
from ims24.configuration.environments import ES_SERVER, ENVIRONMENT, ES_SERVER_PORT
from ims24.contrators.database import getconn
import sqlalchemy.pool as pool


if not os.path.exists("./logs"):
    os.makedirs("./logs")  # pragma: no cover

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
handler_local = RotatingFileHandler(
    f"./logs/{__name__}.log", mode="a", maxBytes=50000, backupCount=10
)
formatter = logging.Formatter("[%(levelname)s] %(asctime)s %(funcName)s -> %(message)s")

# log server elastic search

# %(lineno)d -> if want to log the line when have that print

handler_local.setFormatter(formatter)

ch = logging.StreamHandler(sys.stdout)
ch.setLevel(logging.DEBUG)
formatter2 = logging.Formatter(
    "[%(levelname)s] %(asctime)s [%(funcName)s:%(lineno)d] %(message)s"
)
ch.setFormatter(formatter2)

if ENVIRONMENT == "DEVELOPMENT":  # pragma: no cover
    logger.addHandler(handler_local)
else:  # pragma: no cover
    handler_es = CMRESHandler(
        hosts=[{"host": ES_SERVER, "port": ES_SERVER_PORT}],
        auth_type=CMRESHandler.AuthType.NO_AUTH,
        use_ssl=True,
        es_index_name="ims24",
        es_additional_fields={"project": "ims24", "environment": ENVIRONMENT},
    )
    handler_es.setFormatter(formatter)
    logger.addHandler(handler_es)
logger.addHandler(ch)

# database engine with a pool connection
sql_engine = getconn()
