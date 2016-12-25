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

You can also `exit` and create another PostGIS-enabled container, using something like the following.

``` bash
docker run -itdP --link a-postgis:a-postgis graham3333/mapnik-python
```

With this container, you can connect to the other PostGIS container and run queries like the following.

