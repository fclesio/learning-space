sp_who2 active
   use tempdb                                                        
    go                                                               
                                                                    
    dbcc shrinkfile (tempdev, 1)                                     
    go                                                               
    -- this command shrinks the primary data file                    
                                                                    
    dbcc shrinkfile (templog, 1)                                     
    go                                                               
    -- this command shrinks the log file, look at the last paragraph.
   
