import logging
import time
import module.extraction as extraction
import module.transform as transform
import module.load as load

def main():
    extraction.main()
    transform.main()
    load.main()

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    logging.info('Start ETL ...')
    start_time = time.time()

    main()

    logging.info('End ETL ...')
    elapsed_time = time.time() - start_time
    logging.info('Elapsed Time: %s', elapsed_time)










