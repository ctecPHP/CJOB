DECLARE @codcliente int, 
        @primeironome VARCHAR(30), 
		@sobrenome VARCHAR(60), 
		@nomecompleto VARCHAR(90)
 
-- Cursor para percorrer os registros
DECLARE cursor1 CURSOR FOR
select codcliente, nome, sobrenome from clientes
 
--Abrindo Cursor
OPEN cursor1
 
-- Lendo a próxima linha
FETCH NEXT FROM cursor1 INTO @codcliente, @primeironome, @sobrenome
 
-- Percorrendo linhas do cursor (enquanto houverem)
WHILE @@FETCH_STATUS = 0
BEGIN
 
-- Executando as rotinas desejadas manipulando o registro
update clientes set nomecompleto = @primeironome + ' ' + @sobrenome where codcliente = @codcliente
 
-- Lendo a próxima linha
FETCH NEXT FROM cursor1 INTO @codcliente, @primeironome, @sobrenome
END
 
-- Fechando Cursor para leitura
CLOSE cursor1
 -
- Finalizado o cursor
DEALLOCATE cursor1

