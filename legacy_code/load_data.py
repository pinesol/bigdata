from data_prep import *

taxi_trip = pd.read_csv('/Users/Tian/3sigma/trip_data_12.csv') # Import taxi_trip data
taxi_trip.columns = [i.strip() for i in taxi_trip.columns]
taxi_trip = taxi_trip.drop(['medallion','hack_license','vendor_id','rate_code','store_and_fwd_flag','passenger_count','trip_time_in_secs'] ,1)
taxi_trip.pickup_datetime = pd.to_datetime(taxi_trip.pickup_datetime)
taxi_trip.dropoff_datetime = pd.to_datetime(taxi_trip.dropoff_datetime)
mon_trip = taxi_trip[taxi_trip.pickup_datetime <= pd.datetime(2013, 12, 2)][taxi_trip.pickup_datetime >= pd.datetime(2013,12,1)] # data from 2013/12/01-2013/12/07
mon_trip = mon_trip.append(taxi_trip[taxi_trip.pickup_datetime <= pd.datetime(2013, 12, 9)][taxi_trip.pickup_datetime >= pd.datetime(2013,12,8)])
mon_trip = mon_trip.append(taxi_trip[taxi_trip.pickup_datetime <= pd.datetime(2013, 12, 16)][taxi_trip.pickup_datetime >= pd.datetime(2013,12,15)])

#Random index
random_index = np.random.permutation(len(mon_trip))[:50000]
mon_random_trip = mon_trip.iloc[random_index]

subway_gps = pd.read_csv('/Users/Tian/3sigma/code/3Sigma/subways.csv')
subway_gps = subway_gps.drop('Unnamed: 0', 1)

sub_dict = {}

for i in range(len(subway_gps)):
    sub_dict[subway_gps.STATION[i].strip()] = [subway_gps.LAT[i], subway_gps.LON[i]]

dict_sub = pd.DataFrame(sub_dict).transpose()
dict_sub.index = [i.strip() for i in dict_sub.index]
dict_sub.columns = ['latitude','longitude']
dict_sub['STATION'] = dict_sub.index

def apply_nn(taxi_trip):
    return subway_nearest_neighbor(sub_dict, [taxi_trip.pickup_latitude, taxi_trip.pickup_longitude]).strip()

def apply_nnoff(taxi_trip):
    return subway_nearest_neighbor(sub_dict, [taxi_trip.dropoff_latitude, taxi_trip.dropoff_longitude]).strip()

def date_groupby(start_date, end_date, taxi_trip, sample_size):
    mask1 = taxi_trip.pickup_datetime >= start_date
    mask2 = taxi_trip.pickup_datetime <= end_date
    trip_day = taxi_trip[mask1][mask2]
    random_sample = np.random.permutation(len(trip_day))[:sample_size]
    return trip_day.iloc[random_sample]

mon_random_trip['ON_STATION'] = 0
mon_random_trip['ON_STATION'] = mon_random_trip.apply(apply_nn, 1)
mon_random_trip = pd.merge(mon_random_trip, dict_sub, left_on='ON_STATION', right_on='STATION')
mon_random_trip['OFF_STATION'] = 0
mon_random_trip['OFF_STATION'] = mon_random_trip.apply(apply_nnoff, 1)
mon_random_trip = pd.merge(mon_random_trip, dict_sub, left_on='OFF_STATION', right_on='STATION')
