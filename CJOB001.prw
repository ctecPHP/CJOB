//Bibliotecas
#include 'totvs.ch'

/*/{Protheus.doc} CJOB001
Teste de execução de 'rotina automática' fora do schedule do Protheus 
@type function
@author Ademilson Nunes
@since 10/02/2019
@version 1.0
    @example    	
	"C:\TOTVS 12\ANS\Protheus\bin\smartclient\smartclient.exe" -q -p=U_CJOB001 -c=tcp -e=DEV -m -l
/*/

User Function CJOB001()
	Local 	cEmp 	  := "99"
	Local 	cFil 	  := "01"
	Local 	aTables   := {"SA1"}
	Local   aArea     := GetArea()
	Private cFileLog  := "LOG"+"\LOG_"+ DTOS(DATE()) +"_"+ STRTRAN(TIME(),":","") +".log"
	Private nLogObj   := FCreate(cFileLog)
		
	RpcSetType(3) // Não consome licença	
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )	

	BeginSQL Alias "SQL_SA1"
		SELECT 
			A1_COD,
			A1_NOME
		FROM 
			%table:SA1% SA1 
		WHERE 
			A1_FILIAL = %xFilial:SA1%		
			AND A1_MSBLQL != '1'
			AND SA1.%notDel%
	EndSQL
    
	While ! SQL_SA1->(EoF())
		FWrite(nLogObj, "CODIGO: " + cValToChar(SQL_SA1->A1_COD) + " NOME: " + cValToChar(SQL_SA1->A1_NOME))
		SQL_SA1->(DbSkip())	
	End

	FClose(nLogObj) 

	SQL_SA1->(DbCloseArea())
	RestArea(aArea)	

	RpcClearEnv()
return