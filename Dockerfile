FROM mdillon/postgis

RUN apt-get update -y && \
	apt-get install -y unzip wget

ADD Get_Geogs.sh
