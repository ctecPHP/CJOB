#INCLUDE "TOTVS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} GetApoIn
description - Retorna Informa��es de fonte no RPO
@author  Ademilson Nunes
@since   11/02/2019
@version 1.0
/*/
//-------------------------------------------------------------------
User Function GetApoIn()
Local aRet := {}
 
aRet := GetApoInfo('SFACA001.PRW')
 
MsgInfo( "Nome do fonte: " + aRet[1] + CRLF + ; 
         "Linguagem do fonte: " + aRet[2] + CRLF + ; 
         "Modo de Compila��o: " + aRet[3] + CRLF + ;
         "Data da �ltima modifica��o: " + Dtoc(aRet[4]) + CRLF + ;
         "Hora da �ltima modifica��o: " + aRet[5], "SobelSuprema")
 
Return( Nil )