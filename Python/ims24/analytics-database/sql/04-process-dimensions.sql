
-- dim_address
drop table if exists dw.dim_address;
select
	title as title_key
	,complete_address as address_key
	,city as city_key
	,street
	,postal_code
	,district
	,house_number
into
	dw.dim_address
from
	staging.temp_raw_address;


-- dim_city
drop table if exists dw.dim_city;
select
	title as title_key
	,complete_address as address_key
	,city as city_key
	,city
into
	dw.dim_city
from
	staging.temp_raw_address;


-- dim_district
drop table if exists dw.dim_district;
select
	title as title_key
	,complete_address as address_key
	,district as district_key
	,district
into
	dw.dim_district
from
	staging.temp_raw_address;


-- dim_agency
drop table if exists dw.dim_agency;
SELECT
	 title
	, address as complete_address
	, agency as agency_key
	, agency
into
	dw.dim_agency
FROM
	ods.extracted_raw_table;
