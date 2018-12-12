import module.extraction as extraction
import module.transform as transform
import module.load as load

def main():
    extraction.main()
    transform.main()
    load.main()

if __name__ == '__main__':
    print 'Start ETL ...'
    main()
    print 'End ETL'






