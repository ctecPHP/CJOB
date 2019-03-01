--https://www.devmedia.com.br/trabalhando-com-tipo-datetime-somando-e-subtraindo-horas/23057

/*select * from acesso 
where id_pessoa = 13
order by acesso asc;
select * from pessoa where id = 13;*/

/*SELECT CONVERT(VARCHAR(5),ACESSO,108) AS HORA_BATIDA, ACESSO, ID_PESSOA, TIPO_ACESSO
 FROM ACESSO --Retorna apenas as horas de uma datatime*/
/*SELECT ISNULL(DATEDIFF(HOUR,'2018-08-17 09:22:39','2018-08-17 22:01:53'),0) AS RESULTADO*/
/*SET DATEFORMAT ymd; 
SELECT ACESSO.ACESSO, 
ACESSO.TIPO_ACESSO, 
PESSOA.NOME,
CONVERT(VARCHAR(5),ACESSO.ACESSO,108) AS HORA_ACESSO 
from acesso INNER JOIN PESSOA on PESSOA.ID = ACESSO.ID_PESSOA 
WHERE PESSOA.ID = 13 AND ACESSO.ACESSO BETWEEN '2018-08-17' AND '2018-08-18' 
ORDER BY HORA_ACESSO*/

DELETE FROM PESSOA

