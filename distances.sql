-- set search-path
set search_path to geo,public;

--create index
create index 
on public.property using gist
(geometry)
tablespace pg.default

-- create a sql-function
--create or replace function min_cartesian_dist(in geom geometry)
--returns table ('FID_' float8)
-- parks, metro, hospitals, schools, transport, highways, industrial 
select "FID_",
       parks_dist,
       metro_dist
from (
	SELECT  "FID_" ,
	        st_distance(pr.geometry,p.geometry) as parks_dist,
			MIN(st_distance(pr.geometry,p.geometry)) over(partition by pr."FID_") as min_parks_dist,
			st_distance(pr.geometry,m.geometry) as metro_dist,
			MIN(st_distance(pr.geometry,m.geometry)) over(partition by pr."FID_") as min_metro_dist
	        FROM property as pr
	        join parks p
	        on st_DWithin(pr.geometry, p.geometry, 30000)
	        join metro m
	        on st_DWithin(pr.geometry, m.geometry, 30000)
	  ) tab
where parks_dist=min_parks_dist and metro_dist = min_metro_dist;

