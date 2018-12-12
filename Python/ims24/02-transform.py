#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd

df = pd.read_csv('result.csv')
df[['street', 'row']] = pd.DataFrame(df['Address'].str.split(',',1).tolist(),columns = ['street','row'])
df[['space','postal_code','city','District']] = pd.DataFrame(df['row'].str.split(' ', n=3, expand=True))
df[['street_clean','house_number']] = pd.DataFrame(df['street'].str.split(' ',1).tolist(),columns = ['street','row'])

# Adjustments in Flat size
df['Wohnflaeche'] = df['Wohnflaeche'].str.replace('m²', '')
df['Wohnflaeche'] = df['Wohnflaeche'].str.replace(' ', '')
df['Wohnflaeche'] = df['Wohnflaeche'].str.replace(',', '.')
df['Wohnflaeche'] = pd.to_numeric(df['Wohnflaeche'])

# Adjustments in Floor
df['Etage'] = df['Etage'].astype(str).str[0]

df.columns = ['title','address','apartment_type','floor','square_meters',
              'availability','room','sleep_room','bathroom','district',
              'animals_allowed','base_rent','aditional_costs','heater_tax',
              'total_amount','initial_deposit','agency','url','street',
              'raw_row','space','postal_code','city','street_clean','house_number']

df.drop(['space'], axis=1)

# Adjustments in Flat size
df['base_rent'] = df['base_rent'].str.replace('€', '')
df['base_rent'] = df['base_rent'].str.replace(' ', '')
df['base_rent'] = df['base_rent'].str.replace('+', '')
df['base_rent'] = df['base_rent'].str.replace(' ', '')
df['base_rent'] = df['base_rent'].str.replace('.', '')
df['base_rent'] = df['base_rent'].str.replace(',', '.')
df['base_rent'] = df['base_rent'].str.strip()

df['aditional_costs'] = df['aditional_costs'].str.replace('€', '')
df['aditional_costs'] = df['aditional_costs'].str.replace(' ', '')
df['aditional_costs'] = df['aditional_costs'].str.replace('+', '')
df['aditional_costs'] = df['aditional_costs'].str.replace(' ', '')
df['aditional_costs'] = df['aditional_costs'].str.replace('.', '')
df['aditional_costs'] = df['aditional_costs'].str.replace(',', '.')
df['aditional_costs'] = df['aditional_costs'].str.replace('keineAngabe', '')
df['aditional_costs'] = df['aditional_costs'].str.strip()

df['heater_tax'] = df['heater_tax'].str.replace('€', '')
df['heater_tax'] = df['heater_tax'].str.replace(' ', '')
df['heater_tax'] = df['heater_tax'].str.replace('+', '')
df['heater_tax'] = df['heater_tax'].str.replace(' ', '')
df['heater_tax'] = df['heater_tax'].str.replace('.', '')
df['heater_tax'] = df['heater_tax'].str.replace(',', '.')
df['heater_tax'] = df['heater_tax'].str.replace('inNebenkostenenthalten', '')
df['heater_tax'] = df['heater_tax'].str.replace('nichtinNebenkostenenthalten', '')
df['heater_tax'] = df['heater_tax'].str.replace('keineAngabe', '')
df['heater_tax'] = df['heater_tax'].str.replace('inkl.', '')
df['heater_tax'] = df['heater_tax'].str.replace('nicht', '')
df['heater_tax'] = df['heater_tax'].str.strip()

df['total_amount'] = df['total_amount'].str.replace('€', '')
df['total_amount'] = df['total_amount'].str.replace(' ', '')
df['total_amount'] = df['total_amount'].str.replace('+', '')
df['total_amount'] = df['total_amount'].str.replace(' ', '')
df['total_amount'] = df['total_amount'].str.strip()
df['total_amount'] = df['total_amount'].str.replace('.', '')
df['total_amount'] = df['total_amount'].str.replace(',', '.')
df['total_amount'] = df['total_amount'].str.replace('zzglHeizkosten', '')
df['total_amount'] = df['total_amount'].str.replace('zzglNebenkosten&Heizkosten', '')
df['total_amount'] = df['total_amount'].str.replace('(', '')
df['total_amount'] = df['total_amount'].str.replace(')', '')
df['total_amount'] = df['total_amount'].str.replace('zzglNebenkosten', '')

df['availability'] = df['availability'].str.replace(r"[a-zA-Z]",'')
df['availability'] = df['availability'].str.strip()
df['availability'] = df['availability'].str.replace('!', '')
df['availability'] = df['availability'].str.replace('/', '')
df['availability'] = df['availability'].str.replace('ü', '')
df['availability'] = df['availability'].str.replace('ä', '')
df['availability'] = df['availability'].str.replace(' ', '')

df['room'] = df['room'].str.replace(' ', '')
df['room'] = df['room'].str.replace(',', '.')

df['city'] = df['city'].str.replace(',', '.')
df['city'] = df['city'].str.replace(' ', '')
df['city'] = df['city'].str.replace('.', '')

df['animals_allowed'] = df['animals_allowed'].str.replace('Nach Vereinbarung', 'Arrangement')
df['animals_allowed'] = df['animals_allowed'].str.replace('Ja', 'Yes')
df['animals_allowed'] = df['animals_allowed'].str.replace('Nein', 'No')
df['animals_allowed'] = df['animals_allowed'].str.replace(' ', '')


import psycopg2
import os
from sqlalchemy import text
from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:@0.0.0.0:5432/analytics_ims')

engine.execute(text("update ods.extracted_raw_table set deleted = true where deleted = false;").execution_options(autocommit=True))

df.to_sql('extracted_raw_table', engine, schema='ods', if_exists='append',index=False)

os.remove('result.csv')
