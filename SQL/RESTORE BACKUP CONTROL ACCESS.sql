USE [master]
RESTORE DATABASE [TST_CONTROLE_ACESSO] 
FROM  DISK = N'C:\Backup\controle_acesso-20181018' WITH  FILE = 1,  
MOVE N'controle_acesso' TO N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TST_CONTROLE_ACESSO.mdf',  
MOVE N'controle_acesso_log' TO N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\TST_CONTROLE_ACESSO_log.ldf',  NOUNLOAD,  STATS = 5

GO


