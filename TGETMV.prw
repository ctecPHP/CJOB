#include 'totvs.ch'
    /*/{Protheus.doc} TGETMV
    (long_description)
    @type  get 
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
 User Function TGETMV()
    Local cDbAFV     := 'MSSQL/P12'
    Local cSrvAFV    := '127.0.0.1'
    Local cPrtTopCnn := 7890
    Local aTables    := {'SA1','SB1'}
    Private cFileLog  := "LOG\clientes.log"
	Private nLogObj   := FCreate(cFileLog)
    
    RpcSetType(3)	
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )
    
    nHwnd := TCLink( cDbAFV, cSrvAFV, cPrtTopCnn )

    if nHwnd >= 0
        BeginSQL Alias "SQL_SA1"

		    SELECT 
			    A1_COD,
			    A1_NOME
		    FROM SA1020 SA1 
		    WHERE A1_MSBLQL != '1'
            AND D_E_L_E_T_ = ''

	    EndSQL
    
	        While ! SQL_SA1->(EoF())
		        FWrite(nLogObj, "CODIGO: " + cValToChar(SQL_SA1->A1_COD)  + ;
                                " NOME: "  + cValToChar(SQL_SA1->A1_NOME) + chr(13))
		        SQL_SA1->(DbSkip())	
	        End
    EndIf

    TCUnlink()
    RpcClearEnv()
Return 