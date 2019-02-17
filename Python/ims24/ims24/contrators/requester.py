#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# requester.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 11:06:12

import typing

import requests
from requests_futures.sessions import FuturesSession

from ims24 import logger
from ims24.configuration.environments import BASE_URL_CRAWLER


class RequesterCrawler(object):
    """
    Interface to implement in service
    """

    def __init__(self, base_url: str = ""):
        """
        constructor.... load session and set env variables
            :param self: itself
        """

        self._requester_url = base_url or BASE_URL_CRAWLER
        self._default_headers = {
            "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:65.0) Gecko/20100101 Firefox/65.0",
            "content-type": "text/html",
        }
        self.reset_session()

    def reset_session(self):
        """
        Reset session if necessary.... bootstrap in constructor to load request session
            :param self: itself
        """

        self._requester_session = requests.Session()
        self._requester_session.headers.update(self._default_headers)

    def get_list(
        self, endpoints: tuple, headers: dict = {}, params: dict = {}, **path_params
    ) -> typing.Tuple[object, int]:
        """
        send multiple requests and group by endpoints
            :param self: itself
            :param endpoints:tuple: tuple list with endpoints
            :param headers:dict={}: 
            :param params:dict={}: 
            :param **path_params: 
        """

        dict_responses = {}
        result = {}
        status_code = 200
        wrk_num = self.max_workers_value(endpoints)

        with FuturesSession(max_workers=wrk_num) as session_async:
            session_async.headers.update(self._default_headers)
            for i in endpoints:
                dict_responses[i] = {"url": self._endpoints[i]}
                dict_responses[i]["response"] = session_async.get(
                    dict_responses[i]["url"], params=params, timeout=20
                )
            try:
                for i in endpoints:
                    response = dict_responses[i][
                        "response"
                    ].result()  # block IO... wait for thd response

                    if "application/json" in response.headers["content-type"].lower():
                        result[i] = response.json()
                    else:  # needs to implement parser on your service
                        result[i] = self.html_parser(response.text)
                    logger.info(
                        f"finish request {dict_responses[i]['url']} {response.status_code}"
                    )
            except requests.exceptions.ConnectionError as ex:
                logger.error(f"{ex} \n key : {i} on request {dict_responses[i]}")
                result = f"call procedure {i} failed -> Connection to requester failed"
                raise ex
            except Exception as ex:
                logger.error(f"{ex} \n key : {i} on request {dict_responses[i]}")
                result = f"call procedure {i} failed -> {response.text}"
                raise ex

        return result

    def max_workers_value(self, endpoints: tuple):
        """
        check how many endpoints we have... if have more than 50
        trigger 50 tasks per requests loop
            :param self: itself
            :param endpoints:tuple: ("1","2","3")
        """
        max_conn = len(endpoints) or 1
        if max_conn > 50:
            max_conn = 50

        return max_conn

    def html_parser(self, text: str):
        raise NotImplementedError("Needs to be implement in your service")

