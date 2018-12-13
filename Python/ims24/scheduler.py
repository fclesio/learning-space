import datetime
import time
import module.extraction as extraction
import module.transform as transform
import module.load as load
import module.visualize as visualize

next_start = datetime.datetime(2018, 12, 14, 0, 0, 0)
while True:
    dtn = datetime.datetime.now()

    if dtn >= next_start:
        next_start += datetime.timedelta(hours=1)  # Every hour

        extraction.main()
        transform.main()
        load.main()
        visualize.main()

    time.sleep(3600)
