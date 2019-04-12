#include 'totvs.ch'
#include "TBICONN.ch"

User Function TSTAFV001()

    Local cNumAFV := '1553695498023'
    Local cResult := ''
    Local cFileLog  := "ACACIA\debug.log"
    Local oLog      := FCreate(cFileLog)

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"

        cResult := getPVToB(cNumAFV)
        Fwrite(oLog,  cResult )

    RESET ENVIRONMENT

Return

Static Function getPVToB( cNumAFV)
Local aArea   := GetArea()
Local cResult := ''

	BeginSQL Alias 'AFV'
		SELECT NUMPEDIDOSOBEL AS NPVSOBEL 
			FROM(SELECT NUMPEDIDOSOBEL,
				        CODIGOCLIENTE,
				        NUMPEDIDOAFV,
				        CODIGOTIPOPEDIDO 
		         FROM T_PEDIDO_SOBEL B 
		         WHERE B.NUMPEDIDOAFV IN 
		         (SELECT TAB.ITENS 
			      FROM T_PEDIDO_SOBEL PED 
			      CROSS APPLY F_SPLIT(ISNULL(PED.CESP_NUMPEDIDOASSOC,''),';') TAB 
			      WHERE PED.NUMPEDIDOAFV = %Exp:cNumAFV%)) C 
				  WHERE C.CODIGOCLIENTE =  (SELECT CODIGOCLIENTE 
						  				    FROM T_PEDIDO_SOBEL 
						  				    WHERE NUMPEDIDOAFV = %Exp:cNumAFV%) 
	EndSQL

	While ! AFV->(EoF())
		cResult := cValToChar( AFV->NPVSOBEL )
		AFV->(DbSkip())	
	End

	AFV->(DbCloseArea())
	RestArea(aArea)

Return cResult