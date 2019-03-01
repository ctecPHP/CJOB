DECLARE
       @CONT INT,
	   @ID INT,
	   @TPESSOA INT,
	   @DATA_INI DATE,
	   @DATA_FIN DATE, 
	   @QUERY VARCHAR(1000)	 	      	      
BEGIN 
        SET @CONT = 1
		SET @DATA_INI = '2018-10-01'
		SET @DATA_FIN = '2018-10-31'		
		SET DATEFORMAT ymd

		IF OBJECT_ID('tempdb.dbo.TEMP_REPORT', 'U') IS NOT NULL
        DROP TABLE tempdb.dbo.TEMP_REPORT   

		SELECT ID, ROW_NUMBER() OVER(ORDER BY ID ASC) AS ROW 
		INTO tempdb.dbo.TEMP_REPORT
		FROM PESSOA WHERE STATUS = 'A'

    	SELECT @TPESSOA = COUNT(ID) FROM tempdb.dbo.TEMP_REPORT
		 
		WHILE @CONT <= @TPESSOA
		BEGIN
		      SET @ID = (SELECT ID FROM tempdb.dbo.TEMP_REPORT WHERE ROW = @CONT)		       
			  USE controle_acesso
              SELECT A.ID_PESSOA,
	                 A.ACESSO,
	                 P.NOME, 
                     CONVERT(VARCHAR(5),A.ACESSO,108) AS HORA_ACESSO 
                     FROM ACESSO A
                     INNER JOIN PESSOA P on P.ID = A.ID_PESSOA
                     WHERE ID_PESSOA = @ID AND A.ACESSO 
                     BETWEEN @DATA_INI AND DATEADD(DAY, 1,@DATA_FIN)
                     ORDER BY ACESSO		     			 
		      SET @CONT = @CONT + 1
		END 		
END
GO



     