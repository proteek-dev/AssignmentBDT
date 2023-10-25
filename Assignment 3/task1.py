import os
import pandas as pd
import numpy as np

present_dir = os.getcwd()

dataset_dir = os.path.join(present_dir, 'datasets')
datasets_names = os.listdir(dataset_dir)

def create_dataframe(dataset_dir, datasets_names):
    df = pd.read_parquet(os.path.join(dataset_dir, datasets_names))
    return df

def get_january_dataframe():
    jan_df = create_dataframe(dataset_dir, datasets_names[1])
    return jan_df

def get_march_dataframe():
    mar_df = create_dataframe(dataset_dir, datasets_names[2])
    return mar_df

def get_june_dataframe():
    june_df = create_dataframe(dataset_dir, datasets_names[0])
    return june_df


# jan_df = create_dataframe(dataset_dir, datasets_names[1])
# mar_df = create_dataframe(dataset_dir, datasets_names[2])
# june_df = create_dataframe(dataset_dir, datasets_names[0])

# function to compare the 3 months of data and identify and discuss 3 different trends in it.

# def compare_months(jan_df, mar_df, june_df):
#     # 1. Comparing the number of trips in each month
#     jan_trips = len(jan_df)
#     mar_trips = len(mar_df)
#     june_trips = len(june_df)
#     print(f'Number of trips in January: {jan_trips}')
#     print(f'Number of trips in March: {mar_trips}')
#     print(f'Number of trips in June: {june_trips}')
#     print('\n')
#     # 2. Comparing the number of trips in each month for each vendor
#     jan_vendor_trips = jan_df['vendor_id'].value_counts()
#     mar_vendor_trips = mar_df['vendor_id'].value_counts()
#     june_vendor_trips = june_df['vendor_id'].value_counts()
#     print(f'Number of trips in January for each vendor: \n{jan_vendor_trips}')
#     print(f'Number of trips in March for each vendor: \n{mar_vendor_trips}')
#     print(f'Number of trips in June for each vendor: \n{june_vendor_trips}')
#     print('\n')
#     # 3. Comparing the number of trips in each month for each passenger count
#     jan_passenger_trips = jan_df['passenger_count'].value_counts()
#     mar_passenger_trips = mar_df['passenger_count'].value_counts()
#     june_passenger_trips = june_df['passenger_count'].value_counts()
#     print(f'Number of trips in January for each passenger count: \n{jan_passenger_trips}')
#     print(f'Number of trips in March for each passenger count: \n{mar_passenger_trips}')
#     print(f'Number of trips in June for each passenger count: \n{june_passenger_trips}')
#     print('\n')
#     # 4. Comparing the number of trips in each month for each passenger count
#     jan_trip_distance = jan_df['trip_distance'].describe()
#     mar_trip_distance = mar_df['trip_distance'].describe()
#     june_trip_distance = june_df['trip_distance'].describe()
#     print(f'Trip distance in January: \n{jan_trip_distance}')
#     print(f'Trip distance in March: \n{mar_trip_distance}')
#     print(f'Trip distance in June: \n{june_trip_distance}')
#     print('\n')
    
