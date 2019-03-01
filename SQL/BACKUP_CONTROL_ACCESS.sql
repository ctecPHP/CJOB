/*-------script de Backup Controle de Acesso Sobel-----------*/
/* @Autor:   Ademilson Nunes                                 */
/* @Data:    18/10/2018                                      */     
/* @Versão:  1.0.0                                           */
/*-----------------------------------------------------------*/

DECLARE @fileName varchar(100);
DECLARE @dbName varchar(100);
DECLARE @fileDate varchar(20);

SET @fileName = 'C:\Backup\';
SET @dbName   = 'controle_acesso';
SET @fileDate = CONVERT(varchar(20), GetDate(), 112);
SET @fileName = @fileName + @dbName + '-' + @fileDate + '.BAK'

BACKUP Database @dbName to disk = @fileName;



