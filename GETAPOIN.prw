#INCLUDE "TOTVS.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} GetApoIn
description - Retorna Informações de fonte no RPO
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
         "Modo de Compilação: " + aRet[3] + CRLF + ;
         "Data da última modificação: " + Dtoc(aRet[4]) + CRLF + ;
         "Hora da última modificação: " + aRet[5], "SobelSuprema")
 
Return( Nil )