USE controle_acesso
BEGIN TRANSACTION
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 35
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 36
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 30
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 28
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 43
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 31
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 37
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 38
GO
UPDATE PESSOA 
SET SDP = 'P'
WHERE ID = 34
GO
--COMMIT
SELECT * FROM PESSOA
GO