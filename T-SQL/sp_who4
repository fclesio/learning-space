  
ALTER PROCEDURE [dbo].[sp_who4]  AS  
BEGIN            
 DECLARE @sql_handle binary(20), @handle_found bit            
 DECLARE @stmt_start int, @stmt_end int            
 DECLARE @line nvarchar(4000), @wait_str varchar(8)            
 DECLARE @spid INT , @lastsequence INT,@sequence INT  , @ownspid INT    
 DECLARE @sql VARCHAR(1000)
 DECLARE @EventInfo VARCHAR(2000)
 
	CREATE TABLE #inputbuffer ( id int not null identity(1,1),
	EventType nvarchar(30) ,
	Parameters Int,
	EventInfo nvarchar(255) 
	)
 
       
    SELECT @ownspid = @@spid   
    DECLARE @processes TABLE (sequence int identity(1,1),spid INT, isFilterRunning INT DEFAULT (0), EventInfo nvarchar(2000) )      
    INSERT @processes (spid)      
    select spid from master..sysprocesses where lastwaittype not in ('AWAITING COMMAND','LAZY WRITER','CHECKPOINT SLEEP' ) AND status <> 'sleeping' and spid > 50   and spid <> @ownspid   
        
    SELECT @sequence = 1 ,@lastsequence = max(sequence) from @processes      
          
          
    WHILE (@sequence < @lastsequence)      
    BEGIN      
      SELECT @spid = spid FROM @processes WHERE sequence = @sequence      
     SELECT @sql_handle = sql_handle,            
      @stmt_start = stmt_start/2,            
      @stmt_end = CASE WHEN stmt_end = -1 THEN -1 ELSE stmt_end/2 END            
      FROM master.dbo.sysprocesses            
      WHERE spid = @SPID             
       AND ecid = 0            
             
                 
    SET @line = (             
      SELECT             
       SUBSTRING( text,            
         COALESCE(NULLIF(@stmt_start, 0), 1),            
         CASE @stmt_end             
          WHEN -1             
           THEN DATALENGTH(text)             
          ELSE             
           (@stmt_end - @stmt_start)             
             END            
        )             
         FROM ::fn_get_sql(@sql_handle)            
     )            
    SET @line =    'SPID:' + CAST(@spid as varchar(3))+ '->' + @line        
    RAISERROR(@line, 0, 1) WITH NOWAIT            
    
	SELECT @sql = 'DBCC INPUTBUFFER (' + cast(@spid as varchar(100)) + ')'
    INSERT INTO #inputbuffer ( EventType, Parameters, EventInfo )
	EXECUTE (@sql)


	SELECT TOP 1 @EventInfo = EventInfo FROM #inputbuffer ORDER BY id DESC
	
  
	UPDATE p
		SET EventInfo = @EventInfo
	 FROM @processes p    
	 WHERE Sequence = @sequence
		
	  
    UPDATE p    
  SET isFilterRunning = 1    
  FROM @processes p    
  WHERE Sequence = @sequence    
  AND @line LIKE '%SELECT MIN(FilterItemID) AS FilterItemID, MAX(BindingID) AS BindingID FROM%'    
    SET @sequence = @sequence+1      
   END      
   
   SELECT spid,isFilterRunning, EventInfo FROM @processes ORDER BY isFilterRunning DESC    
END      
      
      
  
  
