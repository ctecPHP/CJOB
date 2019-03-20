#include 'totvs.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} TSTAFV
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
User Function TSTAFV()

    Local cFileLog  := "ACACIA\debug.log"
    Local oLog      := FCreate(cFileLog)
	Local aTables   := {'SA1'}
	Local cResult   := ''

    RpcSetType(3) 

	RpcSetEnv( "01","01", "Administrador", "312rw218", "FAT", "", aTables, , , ,  )
	  
	   cResult := getMSGCli( 23 )
       Fwrite(oLog,  cResult )

    RpcClearEnv()  

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} getMSGCli
	retornar conteúdo de MSGIMPORTACAO
@author  Ademilson Nunes 
@since   18/03/2019
@version 12.1.17
@param nSeq, númerico, PK T_CLIENTENOVO_SOBEL
@return cResult, caracter, msgimportação gravada no registro
/*/
//-------------------------------------------------------------------
Static Function getMSGCli( nSeq )

	Local aArea   := GetArea()
	Local cResult := ''	

	BeginSQL Alias 'AFV'
		SELECT SEQUENCIA,
	   		   ISNULL(MSGIMPORTACAO, '') AS MSGIMP
		FROM T_CLIENTENOVO_SOBEL
		WHERE
		SEQUENCIA = %Exp:nSeq%	   		
	EndSQL

	While !AFV->(EoF())

		cResult := AllTrim( AFV->MSGIMP )
		AFV->(DbSkip())

	End

	AFV->(DbCloseArea())
	RestArea(aArea)	  

Return cResult