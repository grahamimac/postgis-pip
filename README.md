# PostGIS Database with Census Shapefiles

The code and process described here makes the process of creating a PostGIS database with some standard Census geographies, spatially indexed, as easy as possible.

### Setup

First, you will need to [install Docker](https://docs.docker.com/engine/installation/). Then, run the mdillon/postgis Docker container using the following or similar code.

``` bash
docker run -itPd --name my-postgis-name -e POSTGRES_PASSWORD=yourpassword graham3333/postgis-census-pip
```

Enter into the container by running `docker ps -a` and copying the `CONTAINER ID`, which should be a random assortment of numbers and letters such as `d5e50c6d3ae4`. Insert that value into the [CONTAINER ID] text when running the code below.

``` bash
docker exec -it [CONTAINER ID] bash
```

### Get data

The file Get_Geogs.sh should be in the root directory. This file downloads Census shapefiles at the Block Group, Tract, PUMA, ZCTA, County, and State level, inserts them into PostGIS, and creates a spatial index on each table. To start this process, run the following code.

``` bash
./Get_Geogs.sh
```

You can edit the Get_Geogs.sh file to add or remove geographies that you would like in your database, according to the Census [HTTP folder structure](http://www2.census.gov/geo/tiger/). The download and insert processes should take a few minutes, and depend on internet and CPU speeds.

When it's done, to query the data, you can run a command against the database by typing any postgres command, such as the following.

``` bash
psql -U postgres -c "SELECT * FROM bg WHERE geoid = '010010010011'"
```

Or, type `psql -U postgres` to access the PostGres command line and run the query as the following.

``` SQL
SELECT * FROM bg WHERE geoid = '010010010011';
```

### Speed Tests

In the Points folder, I have code to download the NYC Yellow Taxi data and insert the data into a PostGIS table, spatially indexed, in order to test the speed of point in polygon analysis. I use an Amazon Linux AMI m4.large with 2 cores and 8 GB of memory, though CPU speed is the limiting factor, for the following tests.

#### Results

Speed test results, using some example Census geographies. Time is reported in seconds.

Points      | Census Block Group | Census Tract | County
----------- | ------------------ | ------------ | ------
Geographies | 217,739            | 73,056       | 3,233 
125,000 pts | 6 seconds          | 7            | 23     
250,000     | 9                  | 13           | 45     
500,000     | 18                 | 25           | 92
1 Million   | 36                 | 52           | 181
2 Million   | 72                 | 103          | 363
4 Million   | 142                | 207          | 728

PostGIS is more efficient when there are more geographies, possibly because of the indexing method allowing the algorithm to process fewer points intensively per geometry, after the relatively quick first pass with the index. Given there are approximately 50 times more Census Blocks than Block Groups, it is possible that, in the range of millions of points, Census Blocks might be 3 or more times faster than Census Block Groups.