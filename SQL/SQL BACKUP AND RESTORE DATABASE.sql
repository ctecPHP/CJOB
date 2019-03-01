---Backup da base de dados
BACKUP DATABASE [controle_acesso] TO DISK = 'c:\backup\controle_acesso_bkp'

---Restaura��o em outra base para Teste
RESTORE DATABASE [tst_controle_acesso1] FROM DISK = 'c:\backup\controle_acesso_bkp' WITH FILE = 1,
MOVE 'controle_acesso' TO 'c:\DB\tst_controle_acesso1.mdf',  
MOVE 'controle_acesso_log' TO 'c:\DB\tst_controle_acesso1_log.ldf'
GO
/* Descri��o do c�digo */
--> MOVE  'controle_acesso' (nome da base de dados original) 
--> TO 'c:\DB\tst_controle_acesso1.mdf' (diret�rio onde ser� criada a nova base de dados)
--> MOVE 'controle_acesso_log' (nome da base de dados log original) 
--> TO 'TO 'c:\DB\tst_controle_acesso1_log.ldf' (diret�rio onde ser� criada a nova base de dados log)