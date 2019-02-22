#include 'totvs.ch'

// Crio uma função para teste da Classe Exemplo
Function u_teste() 

Local oSoma1 := Exemplo():New() // Crio um novo objeto de exemplo ( objeto 1 ) 
Local oSoma2 := Exemplo():New() // Crio outro objeto de exemplo ( objeto 2 ) 

// Realizo 3 chamadas ao método Soma, com o objeto 1
oSoma1:Soma(10)
oSoma1:Soma(20)
oSoma1:Soma(30)

// Realizo 2 chamadas ao método Soma, com o objeto 2
oSoma2:Soma(30)
oSoma2:Soma(30)

// Imprimo no console o acumulador das somas do obj 1 ( 60 )
conout(oSoma1:nAcumulador)

// Imprimo no console o acumulador das chamadas à soma com o objeto 1 ( 3 )
conout(oSoma1:nChamadas)

// Imprimo no console o acumulador das somas do obj 2 ( 60 )
conout(oSoma2:nAcumulador)

// Imprimo no console o acumulador das chamadas à soma com o objeto 2 (2) 
conout(oSoma2:nChamadas)

Return 

