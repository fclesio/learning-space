#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pandas as pd
import psycopg2
import os
import logging
import time
from sqlalchemy import text
from sqlalchemy import create_engine

host = os.environ["IMS_HOSTNAME"]
user = os.environ["IMS_USERNAME"]
password = os.environ["IMS_PASSWORD"]
dbname = os.environ["IMS_DB_NAME"]
port = os.environ["IMS_PORT"]

engine_string = "postgresql://%s:%s@%s:%s/%s" % (user, password, host, port, dbname)
engine = create_engine(engine_string)


class Transform(object):
    def __init__(self):
        super(Transform, self).__init__()

    @staticmethod
    def load_csv():
        global df
        df = pd.read_csv("result.csv")

    @staticmethod
    def cleasing_1_addresses():
        df[["street", "row"]] = pd.DataFrame(
            df["Address"].str.split(",", 1).tolist(), columns=["street", "row"]
        )
        df[["space", "postal_code", "city", "District"]] = pd.DataFrame(
            df["row"].str.split(" ", n=3, expand=True)
        )
        df[["street_clean", "house_number"]] = pd.DataFrame(
            df["street"].str.split(" ", 1).tolist(), columns=["street", "row"]
        )

    @staticmethod
    def cleasing_2_flat_size():
        # Adjustments in Flat size
        df["Wohnflaeche"] = df["Wohnflaeche"].str.replace("m²", "")
        df["Wohnflaeche"] = df["Wohnflaeche"].str.replace(" ", "")
        df["Wohnflaeche"] = df["Wohnflaeche"].str.replace(",", ".")
        df["Wohnflaeche"] = pd.to_numeric(df["Wohnflaeche"])

    @staticmethod
    def cleasing_3_floor_number():
        # Adjustments in Floor
        df["Etage"] = df["Etage"].astype(str).str[0]

    @staticmethod
    def cleasing_4_set_columns():
        df.columns = [
            "title",
            "address",
            "apartment_type",
            "floor",
            "square_meters",
            "availability",
            "room",
            "sleep_room",
            "bathroom",
            "district",
            "animals_allowed",
            "base_rent",
            "aditional_costs",
            "heater_tax",
            "total_amount",
            "initial_deposit",
            "agency",
            "url",
            "street",
            "raw_row",
            "space",
            "postal_code",
            "city",
            "street_clean",
            "house_number",
        ]

    @staticmethod
    def cleasing_5_drop_unecessary_columns():
        df.drop(["space"], axis=1)

    @staticmethod
    def cleasing_6_adjust_flat_size():
        df["base_rent"] = df["base_rent"].str.replace("€", "")
        df["base_rent"] = df["base_rent"].str.replace(" ", "")
        df["base_rent"] = df["base_rent"].str.replace("+", "")
        df["base_rent"] = df["base_rent"].str.replace(" ", "")
        df["base_rent"] = df["base_rent"].str.replace(".", "")
        df["base_rent"] = df["base_rent"].str.replace(",", ".")
        df["base_rent"] = df["base_rent"].str.strip()

    @staticmethod
    def cleasing_7_adjust_aditional_costs():
        df["aditional_costs"] = df["aditional_costs"].str.replace("€", "")
        df["aditional_costs"] = df["aditional_costs"].str.replace(" ", "")
        df["aditional_costs"] = df["aditional_costs"].str.replace("+", "")
        df["aditional_costs"] = df["aditional_costs"].str.replace(" ", "")
        df["aditional_costs"] = df["aditional_costs"].str.replace(".", "")
        df["aditional_costs"] = df["aditional_costs"].str.replace(",", ".")
        df["aditional_costs"] = df["aditional_costs"].str.replace("keineAngabe", "")
        df["aditional_costs"] = df["aditional_costs"].str.strip()

    @staticmethod
    def cleasing_8_adjust_heater_tax():
        df["heater_tax"] = df["heater_tax"].str.replace("€", "")
        df["heater_tax"] = df["heater_tax"].str.replace(" ", "")
        df["heater_tax"] = df["heater_tax"].str.replace("+", "")
        df["heater_tax"] = df["heater_tax"].str.replace(" ", "")
        df["heater_tax"] = df["heater_tax"].str.replace(".", "")
        df["heater_tax"] = df["heater_tax"].str.replace(",", ".")
        df["heater_tax"] = df["heater_tax"].str.replace("inNebenkostenenthalten", "")
        df["heater_tax"] = df["heater_tax"].str.replace(
            "nichtinNebenkostenenthalten", ""
        )
        df["heater_tax"] = df["heater_tax"].str.replace("keineAngabe", "")
        df["heater_tax"] = df["heater_tax"].str.replace("inkl.", "")
        df["heater_tax"] = df["heater_tax"].str.replace("nicht", "")
        df["heater_tax"] = df["heater_tax"].str.strip()

    @staticmethod
    def cleasing_9_adjust_total_amount():
        df["total_amount"] = df["total_amount"].str.replace("€", "")
        df["total_amount"] = df["total_amount"].str.replace(" ", "")
        df["total_amount"] = df["total_amount"].str.replace("+", "")
        df["total_amount"] = df["total_amount"].str.replace(" ", "")
        df["total_amount"] = df["total_amount"].str.strip()
        df["total_amount"] = df["total_amount"].str.replace(".", "")
        df["total_amount"] = df["total_amount"].str.replace(",", ".")
        df["total_amount"] = df["total_amount"].str.replace("zzglHeizkosten", "")
        df["total_amount"] = df["total_amount"].str.replace(
            "zzglNebenkosten&Heizkosten", ""
        )
        df["total_amount"] = df["total_amount"].str.replace("(", "")
        df["total_amount"] = df["total_amount"].str.replace(")", "")
        df["total_amount"] = df["total_amount"].str.replace("zzglNebenkosten", "")

    @staticmethod
    def cleasing_10_adjust_availability():
        df["availability"] = df["availability"].str.replace(r"[a-zA-Z]", "")
        df["availability"] = df["availability"].str.strip()
        df["availability"] = df["availability"].str.replace("!", "")
        df["availability"] = df["availability"].str.replace("/", "")
        df["availability"] = df["availability"].str.replace("ü", "")
        df["availability"] = df["availability"].str.replace("ä", "")
        df["availability"] = df["availability"].str.replace(" ", "")

    @staticmethod
    def cleasing_11_adjust_room():
        df["room"] = df["room"].str.replace(" ", "")
        df["room"] = df["room"].str.replace(",", ".")

    @staticmethod
    def cleasing_12_adjust_city():
        df["city"] = df["city"].str.replace(",", ".")
        df["city"] = df["city"].str.replace(" ", "")
        df["city"] = df["city"].str.replace(".", "")

    @staticmethod
    def cleasing_13_adjust_animals_allowed():
        df["animals_allowed"] = df["animals_allowed"].str.replace(
            "Nach Vereinbarung", "Arrangement"
        )
        df["animals_allowed"] = df["animals_allowed"].str.replace("Ja", "Yes")
        df["animals_allowed"] = df["animals_allowed"].str.replace("Nein", "No")
        df["animals_allowed"] = df["animals_allowed"].str.replace(" ", "")

    @staticmethod
    def soft_delete_raw_data():
        engine.execute(
            text(
                "update ods.extracted_raw_table set deleted = true where deleted = false;"
            ).execution_options(autocommit=True)
        )

    @staticmethod
    def load_transformed_data():
        df.to_sql(
            "extracted_raw_table", engine, schema="ods", if_exists="append", index=False
        )

    @staticmethod
    def remove_raw_extracted_data():
        os.remove("result.csv")


def main():
    transform = Transform()
    transform.load_csv()
    transform.cleasing_1_addresses()
    transform.cleasing_2_flat_size()
    transform.cleasing_3_floor_number()
    transform.cleasing_4_set_columns()
    transform.cleasing_5_drop_unecessary_columns()
    transform.cleasing_6_adjust_flat_size()
    transform.cleasing_7_adjust_aditional_costs()
    transform.cleasing_8_adjust_heater_tax()
    transform.cleasing_9_adjust_total_amount()
    transform.cleasing_10_adjust_availability()
    transform.cleasing_11_adjust_room()
    transform.cleasing_12_adjust_city()
    transform.cleasing_13_adjust_animals_allowed()
    transform.soft_delete_raw_data()
    transform.load_transformed_data()
    transform.remove_raw_extracted_data()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    logging.info("Transformations Started ...")
    start_time = time.time()

    main()

    logging.info("Transformations finished ...")
    elapsed_time = time.time() - start_time
    logging.info("Elapsed Time: %s", elapsed_time)

