#!/bin/bash

for geog in tabblock10 bg tract puma10; do 
	psql -U postgres -c "CREATE TABLE ${geog} (id serial not null primary key, geoid varchar(15))" 
	psql -U postgres -c "SELECT AddGeometryColumn ('public','${geog}','geom',4269,'MULTIPOLYGON',2);" 
	for i in 01 02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56; do 
		j=`echo ${geog} | awk '{print toupper($0)}'` 
		k= 
		if [[ "$geog" == puma10 ]]; then j=PUMA k=10; fi 
		if [[ "$geog" == tabblock10 ]]; then j=TABBLOCK k=10; fi
		wget http://www2.census.gov/geo/tiger/TIGER2016/${j}/tl_2016_${i}_${geog}.zip -O ${i}.zip 
		unzip ${i}.zip 
		rm ${i}.zip 
		shp2pgsql -I -s 4269 -g geom tl_2016_${i}_${geog}.shp | psql -U postgres -d postgres -q 
		rm tl_2016_${i}_${geog}* 
		psql -U postgres -c "INSERT INTO ${geog} (geoid,geom) (SELECT geoid${k}, geom FROM tl_2016_${i}_${geog})" 
		psql -U postgres -c "DROP TABLE tl_2016_${i}_${geog}" 
	done 
	psql -U postgres -c "CREATE INDEX ${geog}_index ON ${geog} USING GIST (geom)" 
done 
for geog in zcta510 county state; do 
	psql -U postgres -c "CREATE TABLE ${geog} (id serial not null primary key, geoid varchar(12))"
	psql -U postgres -c "SELECT AddGeometryColumn ('public','${geog}','geom',4269,'MULTIPOLYGON',2);"
	j=`echo ${geog} | awk '{print toupper($0)}'` 
	k= 
	if [[ "$geog" == zcta510 ]]; then j=ZCTA5 k=10; fi 
	wget http://www2.census.gov/geo/tiger/TIGER2016/${j}/tl_2016_us_${geog}.zip -O ${geog}.zip 
	unzip ${geog}.zip 
	rm ${geog}.zip 
	shp2pgsql -I -s 4269 -g geom tl_2016_us_${geog}.shp | psql -U postgres -d postgres -q 
	rm tl_2016_us_${geog}* 
	psql -U postgres -c "INSERT INTO ${geog} (geoid,geom) (SELECT geoid${k}, geom FROM tl_2016_us_${geog})" 
	psql -U postgres -c "DROP TABLE tl_2016_us_${geog}" 
	psql -U postgres -c "CREATE INDEX ${geog}_index ON ${geog} USING GIST (geom)" 		
done