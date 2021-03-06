#!/usr/bin/env python
# -*- coding: utf-8 -*-

import csv
import os
import logging
import time
import pandas as pd
import psycopg2
from grab.spider import Spider, Task
from grab import Grab
from sqlalchemy import create_engine

g = Grab()

path = os.path.dirname(os.path.abspath(__file__))

MAIN_LINK = 'http://www.immobilienscout24.de/Suche/S-T/P-{}/Wohnung-Miete/Berlin/Berlin'

THREADS = 10

'''
Data Extraction
- flat size: OK
- number of rooms: OK
    - sleeping rooms (Schlafzimmer): OK, 
    - living rooms (Zimmer): OK, 
    - bathrooms (Badezimmer): OK, 
    - toilets (Badezimmer)
- price
    - cold (Kaltmiete): OK
    - warm (Gesamtmiete): OK
    - additional expenses (Nebenkosten): OK 
    - parking lot price 
location: 
    - city: OK 
    - district: OK, 
    - street: OK
    - house number: OK
    - longitude, latitude 
- agency fact data: 
    - agency name, 
    - agent name, 
    - email, 
    - phone number
- flat advertisement meta data
    - is active
    - when created
    - when updated
    - has flat's pictures
'''

class Immospider(Spider):
    def __init__(self):
        super(Immospider, self).__init__(thread_number=THREADS, network_try_limit=20)
        self.result_file = csv.writer(open('result.csv', 'w'))
        self.result_file.writerow(['Title', 'Address', 'Wohnungstyp', 'Etage', 'Wohnflaeche', 'Bezugsfrei_ab',
                                  'Zimmer', 'Schlafzimmer', 'Badezimmer', 'District','Haustiere', 'Kaltmiete',
                                   'Nebenkosten', 'Heizkosten', 'Gesamtmiete', 'Kaution_o_genossenschaftsanteile',
                                   'Agency','URL'])


    @staticmethod
    def task_generator():
        # Get number of pages
        g.go('http://www.immobilienscout24.de/Suche/S-T/Wohnung-Miete/Berlin/Berlin')
        a = g.xpath_list('//select[@class="select font-standard"]')[0]
        pages = len(a.getchildren())

        for number in xrange(25, 50):
        # for number in xrange(pages+1):
            url = MAIN_LINK.format(number)
            yield Task('initial', url=url)


    def task_initial(self, grab, task):
        items = grab.xpath_list('//h5[@class]')
        for item in items:
            link = item.getparent()
            url = 'http://www.immobilienscout24.de' + link.attrib['href']
            self.add_task(Task(name='get_data', url=url))

    def task_get_data(self, grab, task):
        try:
            title = grab.doc.select('//h1[@id="expose-title"]')[0].text()
        except IndexError:
            title = ' '
        try:
            address = grab.doc.select('//div[@class="address-block"]')[0].text()
        except IndexError:
            address = ' '
        address = ''.join(address.split(' (zur Karte)'))    # garbage text
        try:
            wohnungstyp = grab.doc.select('//dd[@class="is24qa-wohnungstyp grid-item three-fifths"]')[0].text()
        except IndexError:
            wohnungstyp = ' '
        try:
            etage = grab.doc.select('//dd[@class="is24qa-etage grid-item three-fifths"]')[0].text()
        except IndexError:
            etage = ' '
        try:
            wohnflaeche = grab.doc.select('//dd[@class="is24qa-wohnflaeche-ca grid-item three-fifths"]')[0].text()
        except IndexError:
            wohnflaeche = ' '
        try:
            bezugsfrei_ab = grab.doc.select('//dd[@class="is24qa-bezugsfrei-ab grid-item three-fifths"]')[0].text()
        except IndexError:
            bezugsfrei_ab = ' '
        try:
            zimmer = grab.doc.select('//dd[@class="is24qa-zimmer grid-item three-fifths"]')[0].text()
        except IndexError:
            zimmer = ' '
        try:
            schlafzimmer = grab.doc.select('//dd[@class="is24qa-schlafzimmer grid-item three-fifths"]')[0].text()
        except IndexError:
            schlafzimmer = ' '
        try:
            badezimmer = grab.doc.select('//dd[@class="is24qa-badezimmer grid-item three-fifths"]')[0].text()
        except IndexError:
            badezimmer = ' '
        try:
            district = grab.doc.select('//dd[@class="zip-region-and-country"]')[0].text()
        except IndexError:
            district = ' '
        try:
            haustiere = grab.doc.select('//dd[@class="is24qa-haustiere grid-item three-fifths"]')[0].text()
        except IndexError:
            haustiere = ' '
        try:
            kaltmiete = grab.doc.select('//dd[@class="is24qa-kaltmiete grid-item three-fifths"]')[0].text()
        except IndexError:
            kaltmiete = ' '
        try:
            nebenkosten = grab.doc.select('//dd[@class="is24qa-nebenkosten grid-item three-fifths"]')[0].text()
        except IndexError:
            nebenkosten = ' '
        try:
            heizkosten = grab.doc.select('//dd[@class="is24qa-heizkosten grid-item three-fifths"]')[0].text()
        except IndexError:
            heizkosten = ' '
        try:
            gesamtmiete = grab.doc.select('//dd[@class="is24qa-gesamtmiete grid-item three-fifths font-bold"]')[0].text()
        except IndexError:
             gesamtmiete = ' '
        try:
            kaution_o_genossenschaftsanteile = grab.doc.select(
            '//dd[@class="is24qa-kaution-o-genossenschaftsanteile is24-ex-spacelink grid-item three-fifths"]')[0].text()
        except IndexError:
             kaution_o_genossenschaftsanteile = ' '

        # Adjust Agency
        try:
            agency = grab.doc.select(
            '//span[@class="inline-block line-height-xs"]')[0].text()
        except IndexError:
            agency = ' '


        self.result_file.writerow([title.encode('utf-8'), address.encode('utf-8'), wohnungstyp.encode('utf-8'),
                                   etage.encode('utf-8'), wohnflaeche.encode('utf-8'), bezugsfrei_ab.encode('utf-8'),
                                   zimmer.encode('utf-8'), schlafzimmer.encode('utf-8'), badezimmer.encode('utf-8'),
                                   district.encode('utf-8'),haustiere.encode('utf-8'), kaltmiete.encode('utf-8'),
                                   nebenkosten.encode('utf-8'), heizkosten.encode('utf-8'), gesamtmiete.encode('utf-8'),
                                   kaution_o_genossenschaftsanteile.encode('utf-8'), agency.encode('utf-8'), task.url])


def main():
    bot = Immospider()

    try:
        bot.run()
    except KeyboardInterrupt:
        pass

    print bot.render_stats()
    print 'All done'


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    logging.info('Extraction Started ...')
    start_time = time.time()

    main()

    logging.info('Extraction finished ...')
    elapsed_time = time.time() - start_time
    logging.info('Elapsed Time: %s', elapsed_time)