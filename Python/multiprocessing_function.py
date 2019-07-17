import time
import nlp_pre_processing
nlp = nlp_pre_processing.NLPPreprocessor()

# Multiprocessing
from multiprocessing import Pool

start_time = time.time()

num_partitions = 20
num_cores = 15

print(f'Partition Number: {num_partitions} - Number of Cores: {num_cores}...')

def main_process_pipeline(df, func):
    df_split = np.array_split(df, num_partitions)
    pool = Pool(num_cores)
    df = pd.concat(pool.map(func, df_split))
    pool.close()
    pool.join()
    return df

def pre_process_wrapper(df):
    df['full_text'] = df['full_text'].apply(lambda text: nlp.pre_processing_pipeline(text))  
    return df

print('Generate dump with pre-processed data...')
extraction_df = main_process_pipeline(df_sr_events_requests, pre_process_wrapper)

print(f'Pre-Processing in seconds: {(time.time() - start_time)}')
print(f'Pre-Processing in seconds: {(time.time() - start_time)}')
print('Multiprocessing data cleanup done...')
