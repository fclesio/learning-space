--1. Q. How many tasks are currently waiting?
select count(*) from sys.dm_os_waiting_tasks
--2. Q. How many tasks that assigned to a worker (thread/fiber) are waiting?
select count(*) from sys.dm_os_waiting_tasks where wait_type <> 'THREADPOOL'

--What are the tasks waiting on?
select wait_type,count(*) from sys.dm_os_waiting_tasks where wait_type <> 'THREADPOOL' GROUP BY wait_type
--PAGELATCH_UP
--4.    4. Q. Does my load have an active resource bottleneck?
--You can answer this question by looking at the resource address that tasks are blocked on.  Keep in mind that not all wait types have 
--resource associated with them. 
select resource_address,count (*) from sys.dm_os_waiting_tasks WHERE resource_address <> 0 group by resource_address order by count (*) desc

--Q: Is my system can be possibly bottlenecked on I/O?
select * from sys.dm_os_waiting_tasks where wait_duration_ms > 20 AND wait_type LIKE '%PAGEIOLATCH%'

select AVG (work_queue_count) from sys.dm_os_schedulers where status = 'VISIBLE ONLINE'

select pending_disk_io_count from  sys.dm_os_schedulers

 



