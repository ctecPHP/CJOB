DECLARE
        @STARTDATE DATE,
        @ENDDATE DATE

SET @STARTDATE = '19870401';
SET @ENDDATE   = '20181107';

WITH DATERANGE AS
(
  SELECT DT = @STARTDATE
  WHERE @STARTDATE < @ENDDATE
  UNION ALL
  		SELECT DATEADD(DD, 1, DT)
  		FROM DATERANGE
  		WHERE DATEADD(DD, 1, DT) <= @ENDDATE
)
SELECT CONVERT(VARCHAR(MAX),DT,103) AS DATA
FROM DATERANGE
OPTION (MAXRECURSION 0) --'ENCANTAMENTO' PARA REMOVER LIMITA��O DE RECURSIVIDADE
GO
