-- fact_flat
drop table if exists dw.fact_flat;
SELECT
	 title as title_key
	, address as address_key
	, title
	, address as complete_address
	, apartment_type
	, "floor" as floor_number
	, square_meters
	, availability
	, room
	, sleep_room
	, bathroom
	, district as district_key
	, animals_allowed
	, base_rent
	, aditional_costs
	, heater_tax
	, total_amount
	, initial_deposit
	, agency as agency_key
	, url
into
	dw.fact_flat
FROM
	ods.extracted_raw_table;
