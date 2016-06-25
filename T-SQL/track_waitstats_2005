if exists (select * from sys.objects where object_id = object_id(N'[dbo].[track_waitstats_2005]') and OBJECTPROPERTY(object_id, N'IsProcedure') = 1)
	drop procedure [dbo].[track_waitstats_2005]
go
CREATE proc [dbo].[track_waitstats_2005] (@num_samples int=10
								,@delay_interval int=1
								,@delay_type nvarchar(10)='minutes'
								,@truncate_history nvarchar(1)='N'
								,@clear_waitstats nvarchar(1)='Y')
as
--
-- This stored procedure is provided "AS IS" with no warranties, and confers no rights. 
-- Use of included script samples are subject to the terms specified at http://www.microsoft.com/info/cpyright.htm
--
-- T. Davidson
-- @num_samples is the number of times to capture waitstats, default is 10 times
-- default delay interval is 1 minute
-- delaynum is the delay interval - can be minutes or seconds
-- delaytype specifies whether the delay interval is minutes or seconds
-- create waitstats table if it doesn't exist, otherwise truncate
-- Revision: 4/19/05 
--- (1) added object owner qualifier
--- (2) optional parameters to truncate history and clear waitstats
set nocount on
if not exists (select 1 from sys.objects where object_id = object_id ( N'[dbo].[waitstats]') and OBJECTPROPERTY(object_id, N'IsUserTable') = 1)
	create table [dbo].[waitstats] 
		([wait_type] nvarchar(60) not null, 
		[waiting_tasks_count] bigint not null,
		[wait_time_ms] bigint not null,
		[max_wait_time_ms] bigint not null,
		[signal_wait_time_ms] bigint not null,
		now datetime not null default getdate())
If lower(@truncate_history) not in (N'y',N'n')
	begin
	raiserror ('valid @truncate_history values are ''y'' or ''n''',16,1) with nowait	
	end
If lower(@clear_waitstats) not in (N'y',N'n')
	begin
	raiserror ('valid @clear_waitstats values are ''y'' or ''n''',16,1) with nowait	
	end
If lower(@truncate_history) = N'y' 
	truncate table dbo.waitstats
If lower (@clear_waitstats) = N'y' 
	dbcc sqlperf ([sys.dm_os_wait_stats],clear) with no_infomsgs -- clear out waitstats

declare @i int,@delay varchar(8),@dt varchar(3), @now datetime, @totalwait numeric(20,1)
	,@endtime datetime,@begintime datetime
	,@hr int, @min int, @sec int
select @i = 1
select @dt = case lower(@delay_type)
	when N'minutes' then 'm'
	when N'minute' then 'm'
	when N'min' then 'm'
	when N'mi' then 'm'
	when N'n' then 'm'
	when N'm' then 'm'
	when N'seconds' then 's'
	when N'second' then 's'
	when N'sec' then 's'
	when N'ss' then 's'
	when N's' then 's'
	else @delay_type
end
if @dt not in ('s','m')
begin
	raiserror ('delay type must be either ''seconds'' or ''minutes''',16,1) with nowait
	return
end
if @dt = 's'
begin
	select @sec = @delay_interval % 60, @min = cast((@delay_interval / 60) as int), @hr = cast((@min / 60) as int)
end
if @dt = 'm'
begin
	select @sec = 0, @min = @delay_interval % 60, @hr = cast((@delay_interval / 60) as int)
end
select @delay= right('0'+ convert(varchar(2),@hr),2) + ':' + 
	+ right('0'+convert(varchar(2),@min),2) + ':' + 
	+ right('0'+convert(varchar(2),@sec),2)
if @hr > 23 or @min > 59 or @sec > 59
begin
	select 'delay interval and type: ' + convert (varchar(10),@delay_interval) + ',' + @delay_type + ' converts to ' + @delay
	raiserror ('hh:mm:ss delay time cannot > 23:59:59',16,1) with nowait
	return
end
while (@i <= @num_samples)
begin
			select @now = getdate()
            insert into [dbo].[waitstats] ([wait_type], [waiting_tasks_count], [wait_time_ms], [max_wait_time_ms], [signal_wait_time_ms], now)	
			select [wait_type], [waiting_tasks_count], [wait_time_ms], [max_wait_time_ms], [signal_wait_time_ms], @now
				from sys.dm_os_wait_stats
			insert into [dbo].[waitstats] ([wait_type], [waiting_tasks_count], [wait_time_ms], [max_wait_time_ms], [signal_wait_time_ms], now)	
				select 'Total',sum([waiting_tasks_count]), sum([wait_time_ms]), 0, sum([signal_wait_time_ms]),@now
				from [dbo].[waitstats]
				where now = @now
			select @i = @i + 1
			waitfor delay @delay
end
--- create waitstats report
execute dbo.get_waitstats_2005
go
exec dbo.track_waitstats_2005 @num_samples=5
								,@delay_interval=30
								,@delay_type='s'
								,@truncate_history='y'
								,@clear_waitstats='y'
go
