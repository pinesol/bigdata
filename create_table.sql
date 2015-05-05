-- Create table for yellow and green cab info
-- NOTE: You have to 'create' and 'use' a database beforehand. 
-- e.g. 'create database taxi; use database taxi'.

-- NOTE: make sure to change the name of 'testtable.csv'

CREATE TABLE trips (
    color VARCHAR(1),
    pickup_neighborhood VARCHAR(32),
    pickup_borough VARCHAR(9),
    dropoff_neighborhood VARCHAR(32),
    dropoff_borough VARCHAR(9),
    pickup_zone VARCHAR(6),
    dropoff_zone VARCHAR(6),
    pickup_border VARCHAR(6),
    dropoff_border VARCHAR(6),
    pickup_date DATE,
    pickup_hour SMALLINT,
    pickup_longitude DECIMAL(15,10),
    pickup_latitude DECIMAL(15,10),
    dropoff_longitude DECIMAL(15,10),
    dropoff_latitude DECIMAL(15,10),
    passenger_count INTEGER,
    trip_distance DECIMAL(12,4),
    fare_amount DECIMAL(15,4),
    surcharge DECIMAL(15,4),
    mta_tax DECIMAL(15,4),
    tip_amount DECIMAL(15,4),
    tolls_amount DECIMAL(15,4),
    total_amount DECIMAL(15,4),
    num_trips INTEGER
);

CREATE INDEX color_index
ON trips 
(color, zone, pickup_borough, pickup_neighborhood, dropoff_neighborhood);


LOAD DATA LOCAL INFILE 'testtable.csv' 
INTO TABLE trips 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
