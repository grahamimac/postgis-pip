#!/bin/bash
# Modified from http://unix.stackexchange.com/questions/12068/how-to-measure-time-of-program-execution-and-store-that-inside-a-variable
# Modified from http://gis.stackexchange.com/questions/24554/looking-for-fastest-solution-for-point-in-polygon-analysis-of-200-million-points

function pointtest {
	START=$(date +%s)
	psql -U postgis -c "CREATE TABLE test as SELECT tract.geoid as tract_id, taxis.id as taxis_id FROM tract , taxis WHERE taxis.id <=$1 and ST_Dwithin(tract.geom , taxis.geom,0);"
	END=$(date +%s)
	DIFF=$(echo "$END - $START" | bc)
	echo "   Test took $DIFF seconds"
	echo "   Removing test table"
	psql -U postgis -c "DROP TABLE test"
}

echo "Million point test"
pointtest 1000000

echo "10 Million point test"
pointtest 10000000

echo "100 Million point test"
pointtest 100000000

echo "1 Billion point test"
pointtest 1000000000
