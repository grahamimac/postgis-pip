#!/bin/bash

psql -U postgres -c "CREATE TABLE taxis (id serial not null primary key)"
psql -U postgres -c "SELECT AddGeometryColumn ('public','taxis','geom',4269,'POINT',2);"
for y in 2009 2010 2011 2012 2013 2014 2015 2016; do
	a="01 02 03 04 05 06 07 08 09 10 11 12"
	if [[ "$y" == "2016" ]]; then a="01 02 03 04 05 06"; fi
	for i in ${a}; do
		wget https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_${y}-${i}.csv -O data_${y}_${i}.csv
		python get_columns.py data_${y}_${i}.csv
		rm data_${y}_${i}.csv
		psql -U postgres -c "\COPY taxis (geom) FROM data_${y}_${i}_out.csv DELIMITERS ',' CSV"
		rm data_${y}_${i}_out.csv
	done
done
psql -U postgres -c "CREATE INDEX taxi_points ON taxis USING GIST(geom)"