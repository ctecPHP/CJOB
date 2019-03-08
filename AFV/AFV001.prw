#include "totvs.ch"
//#include "tbiconn.ch"

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
    Local   aResult := {'123456', '123456', '123456'}
    Local   nX      := 0
   // Local   cResult := ''
    //Private cFileLog  := "LOG"+"\RESULT.log"
    Private cFileLog  := "ACACIA"+"\RESULT.log
    Private cLogObj   := FCreate(cFileLog)

    RpcSetType(3) 
	RpcSetEnv( "02","01", "Administrador", "312rw218", "FAT", "", aTables, , , ,  )
    //RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )
    //setC5PedBon( getC5Num('1550853723973'), 'TST1')
   // PREPARE ENVIRONMENT EMPRESA '02' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"


    //cResult := getPvAss('W1170303192203130')

    cResult := StrTran( AsString( aResult ), '{', '' )
    cResult := StrTran (cResult, '}', '')
    
    FWrite(cLogObj, 'Resultado: ' + 
    )


    /*
    aResult := getC5NumV('W1100703191809143')

        For nX := 1 to Len(aResult)
            FWrite ( cLogObj, cValToChar( aResult[nX] ) +  " " )    
        Next
    */
    //setC5PedBon('097039', 'TST')

    RpcClearEnv()
   //RESET ENVIRONMENT

Return Nil

/*/{Protheus.doc} getC5Num
    Retorna o C5_NUM do pedido de venda a partir do NUMPEDIDO AFV Acï¿½cia
    @type  Static Function
    @author Ademilson Nunes
    @since 28/02/2019
    @version 12.0.0
    @param cNumAFV, caracter, nï¿½mero do pedido no AFV (T_PEDIDO_SOBEL->NUMPEDIDOAFV)
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
    @param cC5Num, caracter, C5_NUM do pedido que serï¿½ alterado
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

/*/{Protheus.doc} getC5NumV
    
    @type  Static Function
    @author Ademilson Nunes
    @since 07/03/2019
    @version 12.0.0
    @param cC5Num, caracter, C5_NUM do pedido que serï¿½ alterado
    /*/
static function getC5NumV( cNumPvAss )
    Local aVetor  := {}
    Local aResult := {}
    Local nX      := 0
    
    //No minimo 2 pedidos vindos do tablet concatenados por ,
    If ',' $ cNumPvAss .And. Len( cNumPvAss ) >= 27
            aVetor := Strtokarr( cNumPvAss, ',' ) 
            If Len(aVetor) <> 0
                For nX:= 1 to Len(aVetor)
                    AAdd( aResult, getC5Num(cValToChar(aVetor[nX]) ) )
                Next                
            EndIf           
    else 
        AAdd(aResult, getC5Num(cNumPvAss) )
    EndIf
    
Return aResult

//-------------------------------------------------------------------
/*/{Protheus.doc} getPvAss
    Retorna CESP_NUMPEDIDOASSOC, a partir do NUMPEDIDOAFV
    Este campo pode conter, um ou mais código NUMPEDIDOAFV 
    separados por virgula relacionados a um pedido de bonificação
@author  Ademilson Nunes
@since   08/03/2019
@version 12.0.0
@param cNumAFV, caracter, NUMPEDIDOAFV
/*/
//-------------------------------------------------------------------
static function getPvAss( cNumAFV )
    Local cResult := ''
    Local aArea   := GetArea()

    BeginSQL Alias 'AFV'
        SELECT CESP_NUMPEDIDOASSOC AS NPVASS
        FROM  T_PEDIDO_SOBEL   
        WHERE 
        NUMPEDIDOAFV = %Exp:cNumAFV%  
    EndSQL

    While !AFV->(EoF())
        cResult := AllTrim(cValToChar( AFV->NPVASS ))    
        AFV->(DbSkip())
    EndDo

    AFV->(DbCloseArea())
	RestArea(aArea)	
Return cResult
