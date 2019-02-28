#include "totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} AFV001
description
@author  Ademilson Nunes
@since   28/02/2019
@version 12.0.0
/*/
//-------------------------------------------------------------------
User Function AFV001()
    Local 	aTables := {"SC5"}
    Local   cResult := ''
    Private cFileLog  := "ACACIA"+"\RESULT.log"
    Private cLogObj   := FCreate(cFileLog)

    RpcSetType(3) 
	RpcSetEnv( "02","01", "Administrador", "312rw218", "FAT", "", aTables, , , ,  )	

    cResult := getC5Num('1550853723973')
    FWrite(cLogObj, 'Resultado: ' + cResult)

    setC5PedBon('097039', 'TST')


    RpcClearEnv()

Return Nil

/*/{Protheus.doc} getC5Num
    Retorna o C5_NUM do pedido de venda a partir do NUMPEDIDO AFV Acácia
    @type  Static Function
    @author Ademilson Nunes
    @since 28/02/2019
    @version 12.0.0
    @param cNumAFV, caracter, número do pedido no AFV (T_PEDIDO_SOBEL->NUMPEDIDOAFV)
    @return cResult, caracter, retorna o C5_NUM do pedido de venda
    /*/
Static Function getC5Num( cNumAFV )
    Local aArea   := GetArea()
    Local cResult := ''

    BeginSQL Alias 'SQLSC5'
        SELECT C5_NUM
        FROM %table:SC5% SC5  
        WHERE 
        C5_FILIAL = %xFilial:SC5%
        AND C5_HASHPT = %Exp:cNumAFV%
        AND SC5.%notDel%      
    EndSQL

    While ! SQLSC5->(EoF())
        cResult := cValToChar( SQLSC5->C5_NUM )    
        SQLSC5->(DbSkip())
    EndDo

    SQLSC5->(DbCloseArea())
	RestArea(aArea)	
Return cResult

/*/{Protheus.doc} setC5PedBon
    Atualiza campo C5_PEDBON
    @type  Static Function
    @author Ademilson Nunes
    @since 28/02/2019
    @version 12.0.0
    @param cC5Num, caracter, C5_NUM do pedido que será alterado
    /*/
Static Function setC5PedBon( cC5Num, cC5PedBon )
    Local aArea := GetArea()
    Local cLoja := '01'

    DbSelectArea("SC5")
    DbSetOrder(1)
    If DbSeek( xFilial('SC5') + cC5Num + cLoja )
        Begin Transaction 	
            RecLock("SC5", .F.)		
            SC5->C5_PEDBON := cC5PedBon		
            MsUnLock() 
        End Transaction
    EndIf

   SC5->(DbCloseArea())
   RestArea(aArea)
Return Nil
