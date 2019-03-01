SELECT TOP 10
total_worker_time/execution_count AS Avg_CPU_Time
    ,execution_count
    ,total_elapsed_time/execution_count as AVG_Run_Time
    ,(SELECT
          SUBSTRING(text,statement_start_offset/2,(CASE
                                                       WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 
                                                       ELSE statement_end_offset 
                                                   END -statement_start_offset)/2
                   ) FROM sys.dm_exec_sql_text(sql_handle)
     ) AS query_text 
FROM sys.dm_exec_query_stats 
ORDER BY Avg_CPU_Time DESC
--ORDER BY AVG_Run_Time DESC
--ORDER BY execution_count DESC
/*https://msdn.microsoft.com/magazine/msdn-magazine-issues*/
