# Size of the chunk
n = 100  

# Array that contains our objects
df_list_ = []

# Create a list which will have the number of positions
# equals total_records / n. In this example we have 20 chunks
# To access every chunk we need to use list[i] where i = integer
list_df = [df_test[i:i+n] for i in range(0, df_test.shape[0], n)]

# Control variable to interate in all objects of the array
max_chunks = len(list_df)

## Lemmatization Section
start_time = time.time()

for x in range(0, max_chunks): 
    # In this very specific case we'll use 
    # a Chained Assignment, because for us don't
    # matter if the df it's lost for every sequence 
    # of the assignments
    pd.options.mode.chained_assignment = None
    
    # Lets access one element from the list (a DF) and use
    # this element as DF
    df_to_process = list_df[x]

    # Lets use or function to process the chunk
    df_to_process['text_lemmatized'] = df_to_process.text.apply(lemmatize_text)

    # Put DF in the list
    df_list_.append(df_to_process)

    # Concatenate all data and load the dataframe
    df_full_records_lemma = pd.concat(df_list_, axis = 0, ignore_index = True)

    print(f'Qty of Rows: {df_full_records_lemma.shape[0]}')
    
    time_elapsed = time.time() - start_time
    print(f'Partial time elapsed: {time.strftime("%H:%M:%S", time.gmtime(time_elapsed))}')

time_elapsed = time.time() - start_time
print(f'Time elapsed (Lemmatization): {time.strftime("%H:%M:%S", time.gmtime(time_elapsed))}')
