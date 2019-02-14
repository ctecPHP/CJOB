#include 'TOTVS.ch'
/*/{Protheus.doc} CJOBSQL
    (long_description)
    @type  Function
    @author Ademilson Nunes
    @since 11/02/2019
    @version 12.0.0
    /*/

User Function CJOBSQL()
    Local   cEmp      := '99'
    Local   cFilia    := '01'
    Local   aTables   := {'SA1'}
    Local   aArea     := GetArea()
    Private cFileLog  := "LOG"+"\CLIENTES.log"
	Private cLogObj   := FCreate(cFileLog)

    RpcSetType(3)	
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )	

    BeginSQL Alias 'CLIENTES'
        SELECT A1_COD,
               A1_NOME
        FROM %table:SA1% SA1
        WHERE 
            A1_FILIAL = %xFilial:SA1%		
			AND A1_MSBLQL != '1'
			AND SA1.%notDel%       
    EndSQL

    While ! CLIENTES->(EoF())
		FWrite(cLogObj, "CODIGO: " + cValToChar(CLIENTES->A1_COD) + " NOME: " + cValToChar(CLIENTES->A1_NOME))
		CLIENTES->(DbSkip())	
	End

	FClose(cLogObj) 

	CLIENTES->(DbCloseArea())
	RestArea(aArea)	


// Exemplo de uso para Windows 1
    shellExecute("Open", "%windir%\system32\cmd.exe", " /k notepad c:\TOTVS 12\ANS\protheus_data\log\cliente.log", "c:\TOTVS 12\ANS\protheus_data\log", 1 )    
	RpcClearEnv()

Return
