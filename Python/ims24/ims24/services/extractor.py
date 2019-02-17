#!/usr/bin/env python3.6
# -*- coding: utf-8 -*-
#
# extractor.py
# @Author : Gustavo F (gustavo@gmf-tech.com)
# @Link   : https://github.com/sharkguto
# @Date   : 17/02/2019 11:38:47


from ims24.contrators.requester import RequesterCrawler


class Extractor(RequesterCrawler):
    """
    implement RequesterCrawler class to do multiple requests async 
    using Future 
        :param RequesterCrawler: RequesterCrawler object
    """

    _endpoints = {}

    def __init__(self, base_url: str = ""):
        """
        pass base_url or get from env variable
            :param self: itself
            :param base_url:str="": base_url
        """
        super().__init__(base_url)
        self.load_endpoints()

    def load_endpoints(self):
        """
        load endpoints dict 
            :param self: itself
        """
        for i in range(4000):

            self._endpoints[f"{i}"] = self._requester_url.format(pagination=i)

    def return_data(self):
        """
        run crawler and return results
            :param self: itself
        """

        self.get_list(tuple(self._endpoints.keys()))

    def html_parser(self, text: str):
        """
        convert html to json
            :param self: itself
            :param text:str: html text to be parsed
        """

