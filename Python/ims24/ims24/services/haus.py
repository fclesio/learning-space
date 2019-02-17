#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# haus.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 12:32:47

from ims24.contrators.requester import RequesterCrawler
import html5lib
import re


class ExtractorHaus(RequesterCrawler):
    """
    implement RequesterCrawler class to do multiple requests async 
    using Future 
        :param RequesterCrawler: RequesterCrawler object
    """

    _endpoints = {}

    def __init__(self, list_haus: dict):
        """
        pass base_url or get from env variable
            :param self: itself
            :param base_url:str="": base_url
        """
        super().__init__(base_url)
        self._endpoints = list_haus

    def return_data(self):
        """
        run crawler and return a list of haus results
            :param self: itself
        """

        self.get_list(tuple(self._endpoints.keys()))

    def html_parser(self, text: str):
        """
        convert html to json
            :param self: itself
            :param text:str: html text to be parsed
        """
        list_ids_haus = self.regex_link.findall(text)

        self._endpoints_dive = {
            **self._endpoints_dive,
            **{
                f"{id_haus}": f"https://www.immobilienscout24.de/expose/{id_haus}"
                for id_haus in list_ids_haus
            },
        }

        print(self._endpoints_dive)
