import dask.dataframe as dd
import pandas as pd

df = dd.read_csv('./data/processed_blocks/*.csv')

keep_cols  = ['gisjoin', 'name','state','H72001_sf', 'H72003_sf', 'H72004_sf', 'H72005_sf', 'H72006_sf', 'H72007_sf', 'H72008_sf', 'H72009_sf', 'H73002_sf', 'H72001_dp', 'H72003_dp', 'H72004_dp', 'H72005_dp', 
'H72006_dp', 'H72007_dp', 'H72008_dp', 'H72009_dp', 'H73002_dp', 'white_popchange', 'black_popchange', 'aian_popchange', 'asian_popchange', 'nhpi_popchange', 'other_popchange', 'twoplus_popchange', 'hispanic_popchange', 'white_pct_dp', 'black_pct_dp', 'aian_pct_dp', 'asian_pct_dp', 'nhpi_pct_dp', 'other_pct_dp', 'twoplus_pct_dp', 'hispanic_pct_dp', 'white_pct_sf', 'black_pct_sf', 'aian_pct_sf', 'asian_pct_sf', 'nhpi_pct_sf', 'other_pct_sf', 'twoplus_pct_sf', 'hispanic_pct_sf', 'white_pct_change', 'black_pct_change', 'aian_pct_change', 'asian_pct_change', 'nhpi_pct_change', 'other_pct_change', 'twoplus_pct_change', 
'hispanic_pct_change']

drop_cols = [c for c in df.columns if c not in keep_cols]

df = df.drop(columns = drop_cols)

national_file = df.compute()

national_file.to_csv('national_blocks_june_dp.csv')