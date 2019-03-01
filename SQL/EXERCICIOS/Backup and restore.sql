--Backup de uma base de dados
BACKUP DATABASE [nomebanco] TO DISK = 'c:\backup\nomebanco_bkp.bak'

--Restaurar base de dados em outro banco para testes
RESTORE DATABASE [nomebanco_teste] FROM DISK = 'c:\backup\nomebanco_bkp.bak' with file = 1,
MOVE 'nomebanco' TO 'c:\diretorioDaBase\nomebanco.mdf', 
MOVE 'nomebanco_log' TO 'c:\diretorioDaBase\nomebanco_log.ldf'
GO

