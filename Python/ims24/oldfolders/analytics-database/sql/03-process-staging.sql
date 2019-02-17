
drop table if exists staging.temp_raw_address;
create table staging.temp_raw_address
AS
SELECT
	 title
	, address as complete_address
	, street
	, postal_code
	, district
	, city
	, street_clean
	, house_number
FROM
	ods.extracted_raw_table
where
	deleted = false;




update  staging.temp_raw_address
set street_clean = street_clean || ' Allee '
where lower(house_number) like '%allee%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Allee', '')
where lower(house_number) like '%allee%';

update  staging.temp_raw_address
set street_clean = ''
where lower(house_number) like '%berlin%';

update  staging.temp_raw_address
set street_clean = street_clean || ' Damm '
where lower(house_number) like '%damm%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Damm', '')
where lower(house_number) like '%damm%';

update  staging.temp_raw_address
set street_clean = street_clean || ' Str. '
where lower(house_number) like '%str.%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Str.', '')
where lower(house_number) like '%str.%';

update  staging.temp_raw_address
set street_clean = street_clean || ' Strasse '
where lower(house_number) like '%strasse%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Strasse', '')
where lower(house_number) like '%strasse%';

update  staging.temp_raw_address
set street_clean = street_clean || ' Straße '
where lower(house_number) like '%straße%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Straße', '')
where lower(house_number) like '%straße%';

update  staging.temp_raw_address
set street_clean = street_clean || ' Weg '
where lower(house_number) like '%weg%';

update  staging.temp_raw_address
set house_number = replace(house_number, 'Weg', '')
where lower(house_number) like '%weg%';


update  staging.temp_raw_address
set house_number = NULL
where lower(house_number) like '%berlin%';


update  staging.temp_raw_address
set city = 'Berlin'
where lower(city) like '%berlin%';


update  staging.temp_raw_address
set city = 'Berlin'
where city is NULL;


update  staging.temp_raw_address
set postal_code = left(street, 5)
where postal_code is NULL;
