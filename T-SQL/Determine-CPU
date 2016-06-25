--  1. Reset Wait Stats
    dbcc sqlperf('sys.dm_os_wait_stats', clear)  --example provided by www.sqlworkshops.com

  --  2. Apply workload (you can find sample workload query at the end of this article, you need to execute the sample workload query simultaneously in many sessions to simulate concurrent user tasks).

--    3. Run the below query to find Additional CPUs Necessary  it is important to run the query right after the workload completes to get reliable information.
    select round(((convert(float, ws.wait_time_ms) / ws.waiting_tasks_count) / (convert(float, si.os_quantum) / si.cpu_ticks_in_ms) * cpu_count), 2) as Additional_CPUs_Necessary,
    round((((convert(float, ws.wait_time_ms) / ws.waiting_tasks_count) / (convert(float, si.os_quantum) / si.cpu_ticks_in_ms) * cpu_count) / hyperthread_ratio), 2) as Additional_Sockets_Necessary
    from sys.dm_os_wait_stats ws cross apply sys.dm_os_sys_info si where ws.wait_type = 'SOS_SCHEDULER_YIELD'  --example provided by www.sqlworkshops.com
