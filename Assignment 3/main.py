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
