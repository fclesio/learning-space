-- Numerical fields convension
alter table dw.fact_flat
alter column total_amount type numeric(16,2)
  USING total_amount::numeric(16,2);

alter table dw.fact_flat
alter column base_rent type numeric(16,2)
  USING base_rent::numeric(16,2);

alter table dw.fact_flat
alter column square_meters type numeric(16,2)
  USING square_meters::numeric(16,2);

alter table dw.fact_flat
alter column room type numeric(16,2)
  USING room::numeric(16,2);
