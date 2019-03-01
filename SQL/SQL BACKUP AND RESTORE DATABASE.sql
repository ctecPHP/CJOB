---Backup da base de dados
BACKUP DATABASE [controle_acesso] TO DISK = 'c:\backup\controle_acesso_bkp'

---Restauração em outra base para Teste
RESTORE DATABASE [tst_controle_acesso1] FROM DISK = 'c:\backup\controle_acesso_bkp' WITH FILE = 1,
MOVE 'controle_acesso' TO 'c:\DB\tst_controle_acesso1.mdf',  
MOVE 'controle_acesso_log' TO 'c:\DB\tst_controle_acesso1_log.ldf'
GO
/* Descrição do código */
--> MOVE  'controle_acesso' (nome da base de dados original) 
--> TO 'c:\DB\tst_controle_acesso1.mdf' (diretório onde será criada a nova base de dados)
--> MOVE 'controle_acesso_log' (nome da base de dados log original) 
--> TO 'TO 'c:\DB\tst_controle_acesso1_log.ldf' (diretório onde será criada a nova base de dados log)