#!/bin/bash
# Modified from http://unix.stackexchange.com/questions/12068/how-to-measure-time-of-program-execution-and-store-that-inside-a-variable
# Modified from http://gis.stackexchange.com/questions/24554/looking-for-fastest-solution-for-point-in-polygon-analysis-of-200-million-points

function pointtest {
	START=$(date +%s)
	psql -U postgres -c "CREATE TABLE test as SELECT tract.geoid as tract_id, taxis.id as taxis_id FROM tract , taxis WHERE taxis.id <=$1 and ST_Dwithin(tract.geom , taxis.geom,0);"
	END=$(date +%s)
	DIFF="$(($END-$START))"
	echo "   Test took $DIFF seconds"
	echo "   Removing test table"
	psql -U postgres -c "DROP TABLE test"
}

echo "125,000 point test"
pointtest 125000

echo "250,000 point test"
pointtest 250000

echo "500,000 point test"
pointtest 500000

echo "1 Million point test"
pointtest 1000000

echo "2 Million point test"
pointtest 2000000

echo "4 Million point test"
pointtest 4000000