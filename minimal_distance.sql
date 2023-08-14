create table distances as ( 
	select "FID_", centre_dist,
			parks_dist,
			metro_dist,
			hospitals_dist,
			schools_dist,
			transport_dist,
			highways_dist,
			industrial_dist,
			heavy_dist
	from property pr
	left join lateral

                (  --centre

                         SELECT  st_distance(pr.geometry,c.geometry) as centre_dist
                                        FROM centre c
                                order by pr.geometry <-> c.geometry
                                limit 1
                ) as t_centre
       on true
       left join lateral
		(   -- parks 
			SELECT  st_distance(pr.geometry,p.geometry) as parks_dist
					FROM parks p
			        order by pr.geometry <-> p.geometry
			        limit 1
		)as t_parks		
	on true			
	left join lateral
		(   -- metro
			SELECT  st_distance(pr.geometry,m.geometry) as metro_dist
			        from metro m
			        order by pr.geometry <-> m.geometry
			        limit 1
		) as t_metro
	on true
	left join lateral
		(   -- hospitals
			SELECT  st_distance(pr.geometry,h.geometry) as hospitals_dist
			        from hospitals h
			        order by pr.geometry <-> h.geometry
			        limit 1
		) as t_hospitals
	on true 
	left join lateral
		(   -- schools
			SELECT  st_distance(pr.geometry,s.geometry) as schools_dist
			        from schools s
			        order by pr.geometry <-> s.geometry
			        limit 1
		) as t_schools
	on true 
	left join lateral
		(   -- transport
			SELECT  st_distance(pr.geometry,t.geometry) as transport_dist
			        from transport t
			        order by pr.geometry <-> t.geometry
			        limit 1
		) as t_transport
	on true 
	left join lateral
		(   -- highways
			SELECT  st_distance(pr.geometry,hi.geometry) as highways_dist
			        from highways hi
			        order by pr.geometry <-> hi.geometry
			        limit 1
		) as t_highways
	on true 
	left join lateral
		(
			SELECT  st_distance(pr.geometry,i.geometry) as industrial_dist
			        from industrial i
			        order by pr.geometry <-> i.geometry
			        limit 1
		) as t_industrial
	on true 
		left join lateral
		(
			SELECT  st_distance(pr.geometry,hi.geometry) as heavy_dist
			        from heavy_ind hi
			        order by pr.geometry <-> hi.geometry
			        limit 1
		) as t_heavy
	on true 	
							)
