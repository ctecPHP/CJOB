BACKUP DATABASE controle_acesso TO DISK = 'c:\backup\controle_acesso_181129_1709.bak'
GO
-------------------------------------------------------------------------------------
SELECT *
INTO controle_acesso.dbo.acesso_bkp
FROM controle_acesso.dbo.ACESSO
GO
-------------------------------------------------------------------------------------
SELECT * FROM controle_acesso.dbo.acesso_bkp
GO
-------------------------------------------------------------------------------------
SELECT * FROM controle_acesso.dbo.acesso
GO
-------------------------------------------------------------------------------------
EXEC SP_RENAME 'acesso_bkp', 'acesso.123'
GO
-------------------------------------------------------------------------------------
RESTORE DATABASE hom_controle_acesso 
FROM DISK = 'c:\backup\controle_acesso_181129_1709.bak' WITH FILE = 1,
MOVE 'controle_acesso' TO 'c:\DB\CONTROLE\CA.mdf',
MOVE 'controle_acesso_log' TO 'c:\DB\CONTROLE\CA.ldf'
GO
-------------------------------------------------------------------------------------

