create table distances as (
	select "FID_",
			parks_dist,
			metro_dist
	from property pr
	left join lateral
	(
		SELECT  st_distance(pr.geometry,p.geometry) as parks_dist,
				MIN(st_distance(pr.geometry,p.geometry)) over(partition by pr."FID_") as min_parks_dist
				FROM parks p
		        order by st_DWithin(pr.geometry, p.geometry, 30000)
	) as t_parks		
	on true			
	left join lateral
	(
		SELECT  st_distance(pr.geometry,m.geometry) as metro_dist,
				MIN(st_distance(pr.geometry,m.geometry)) over(partition by pr."FID_") as min_metro_dist
		        from metro m
		        order by st_DWithin(pr.geometry, m.geometry, 30000)
	) as t_metro
	on true 
)