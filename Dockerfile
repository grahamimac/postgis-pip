FROM mdillon/postgis

RUN apt-get update -y && \
	apt-get install -y unzip wget

COPY Get_Geogs.sh /
