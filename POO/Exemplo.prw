#INCLUDE "PROTHEUS.CH"
// --------------------------------------------------------------------------------
// Declaracao da Classe Exemplo
// --------------------------------------------------------------------------------

CLASS Exemplo 

// Declaracao das propriedades da Classe
DATA nAcumulador
DATA nChamadas

// Declara��o dos M�todos da Classe
METHOD New() CONSTRUCTOR
METHOD Soma( nNum ) 

ENDCLASS

// Cria��o do construtor, onde atribuimos os valores default 
// para as propriedades e retornamos Self
METHOD New() Class Exemplo
::nAcumulador := 0
::nChamadas := 0
Return Self

// Cria��o do M�todo de Soma , que recebe um n�mero e o soma 
// ao acumulador, retornando o conteudo do acumululador ap�s
// a soma , e incrementa em 1 o contador de chamadas do m�todo
METHOD Soma( nNum ) Class Exemplo
::nAcumulador += nNum
::nChamadas++
Return ::nAcumulador

User Function Exemplo()
Return( NIL )

// Crio uma fun��o para teste da Classe Exemplo
Function u_teste() 

Local oSoma1 := Exemplo():New() // Crio um novo objeto de exemplo ( objeto 1 ) 
Local oSoma2 := Exemplo():New() // Crio outro objeto de exemplo ( objeto 2 ) 

// Realizo 3 chamadas ao m�todo Soma, com o objeto 1
oSoma1:Soma(10)
oSoma1:Soma(20)
oSoma1:Soma(30)

// Realizo 2 chamadas ao m�todo Soma, com o objeto 2
oSoma2:Soma(30)
oSoma2:Soma(30)

// Imprimo no console o acumulador das somas do obj 1 ( 60 )
conout(oSoma1:nAcumulador)

// Imprimo no console o acumulador das chamadas � soma com o objeto 1 ( 3 )
conout(oSoma1:nChamadas)

// Imprimo no console o acumulador das somas do obj 2 ( 60 )
conout(oSoma2:nAcumulador)

// Imprimo no console o acumulador das chamadas � soma com o objeto 2 (2) 
conout(oSoma2:nChamadas)

Return 