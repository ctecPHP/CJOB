#include 'totvs.ch'
/*/{Protheus.doc} AFVRECCLI
        Cadastra novos clientes vindos do AFV 'Acacia' 
    @type  Function
    @author Ademilson Nunes / Elvis Kinuta
    @since 14/03/2019
    @version 12.1.17
/*/
/*  TODO_LIST    
    	 
        1 - Disparar e-mail para o departamento de TI com o 
		
		conte�do do log em caso de erro.
		2 - Disparar e-mail para financeiro/ 		
*/
User Function AFVRECCLI()

	Private	cFil 	  := "01"
	Private cUser     := "Administrador"
	Private cPsw      := "312rw218"
	Private	aTables   := {"SA1"}
	Private aReg      := {}
	Private aResult   := {}
	Private nX        := 0
	Private cUnidFat  := ''
	Private nSeq      := 0
	Private nCount    := 0
	Private cCNPJ     := ''
	Private cA1Cod    := ''
	Private cFileLog  := "ACACIA\CLIENTES"+"\ERRO_"+ DTOS(DATE()) +"_" + STRTRAN(TIME(),":","") + ".log"
	
	prepEnv( "01" )

		aReg := findNewCli()

	closeEnv() 

	//Conta número de novos registros em T_CLIENTENOVO_SOBEL 
	nCount := Len(aReg[1])

	If nCount > 0

		For nX := 1 to nCount	

			// recebe PK da T_CLIENTENOVO_SOBEL
        	nSeq     := Val(aReg[1][nX])

			// recebe unidade de faturamento - 01 - SOBEL | 02 - JMT | 04 - 3F
			cUnidFat := cValToChar(aReg[2][nX])

			// prepara o ambiente de acordo com a empresa
			prepEnv( cUnidFat )	
				
				// recebe coleção de dados para o novo registro
				aResult := getNewCli( nSeq )				
				// chama MSExecAuto - MATA030 - Cadastro de Clientes ( Tabela SA1 )
				recSA1( aResult, cUnidFat ) 	

			closeEnv()	// Desmonta ambiente

		Next nX

	EndIf
	
Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} setA1Cod
	Executa um UPDATE na tabela T_CLIENTENOVO_SOBEL, atualizando 
	a coluna CODIGOERP do registro com o A1_COD gerado após gravação 
	do cliente através da rotirna MATA030 via MSExecAuto e atualiza 
	tambem a DATAINTEGRACAOERP e adiciona o valor '01' a coluna LOJACLIENTE.
@author  Ademilson Nunes
@since   16/03/2019
@version 12.1.17
/*/
//-------------------------------------------------------------------
Static Function setA1Cod( cCNPJ, cA1Cod )

	Local cQry := ''

	cQry := " UPDATE T_CLIENTENOVO_SOBEL " 
	cQry += " SET DATAINTEGRACAOERP = CAST(GETDATE() AS DATETIME), "
	cQry += " CODIGOERP = '"  + cA1Cod + "', "
	cQry += " LOJACLIENTE = '01' "
	cQry += " WHERE  CNPJ = '" + cCNPJ + "' "

	TCSqlExec(cQry)

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} getA1Cod
description
@author  Ademilson Nunes
@since   date
@version version
/*/
//-------------------------------------------------------------------
Static Function getA1Cod( cCNPJ )

	Local aArea   := GetArea()
	Local cResult := ''

	BeginSQL Alias 'AFV'

		SELECT A1_COD 
		FROM %table:SA1% SA1 
		WHERE 
		A1_CGC = %Exp:cCNPJ%
		AND SA1.%notDel%	

	EndSQL

	While !AFV->(EoF())

		cResult := AllTrim(cValtoChar( AFV->A1_COD ))
		AFV->(DbSkip())

	End

	AFV->(DbCloseArea())
	RestArea(aArea)	  

Return cResult


//-------------------------------------------------------------------
/*/{Protheus.doc} prepEnv
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Static Function prepEnv( cEmp )

	RpcSetType(3) 
	RpcSetEnv( cEmp, cFil, cUser, cPsw, "FAT", "", aTables, , , ,  )

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} closeEnv
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
Static Function closeEnv()

	RpcClearEnv()

Return Nil


/*/{Protheus.doc} findNewCli
    (long_description
    @type  Static Function
    @author  Ademilson Nunes / Elvis Kinuta
    @since date
    @version version   
    @return return, return_type, return_description
    /*/
Static Function findNewCli()

	Local aArea   := GetArea()
	Local aResult := {}
	Local aReg    := {}
	Local aEmp    := {}	

	BeginSQL Alias 'AFV'

		SELECT SEQUENCIA,
	   		   CODIGOUNIDFAT
        FROM T_CLIENTENOVO_SOBEL
		WHERE DATAINTEGRACAOERP IS NULL 
		AND CODIGOERP IS NULL
		ORDER BY CODIGOUNIDFAT	

	EndSQL

	While !(AFV->(EoF()))

		// PK  T_CLIENTENOVO_SOBEL
		AAdd( aReg, AllTrim(cValToChar(AFV->SEQUENCIA)) ) 
		// CODIGOUNIDFAT - 01 - SOBEL | 02 - JMT | 04 - 3F
		AAdd( aEmp, AllTrim(AFV->CODIGOUNIDFAT) )

		AFV->(DbSkip())

	End

	AAdd( aResult, aReg )
	AAdd( aResult, aEmp )

	AFV->(DbCloseArea())
	RestArea(aArea)	    

Return aResult


/*/{Protheus.doc} getNewCli
	Retorna coleção de dados da tabela T_NOVOCLIENTE_SOBEL para registro de novos clientes
    @type  Static Function
    @author  Ademilson Nunes / Elvis Kinuta
    @since 16/03/2019
    @version 12.1.17    
	@param nSeq, numerico, PK do registro solicitado
    @return aResult, array, coleção de dados para MSExecAuto.
    /*/
Static Function getNewCli( nSeq )

  	Local aArea   := GetArea()
	Local aResult := {}	

    BeginSQL Alias 'AFV'

        SELECT	ISNULL(CESP_CODIGOIBGE   , '')  AS CESP_CODIGOIBGE   ,
		        ISNULL(CODIGOUNIDFAT     , '')  AS CODIGOUNIDFAT     ,
		        ISNULL(LOJACLIENTE       , '')  AS LOJACLIENTE       ,
		        ISNULL(RAZAOSOCIAL       , '')  AS RAZAOSOCIAL	     ,
		        ISNULL(NOMEREDUZIDO      , '')  AS NOMEREDUZIDO      ,
		        ISNULL(ENDERECO          , '')  AS ENDERECO          ,
		        ISNULL(ESTADO            , '')  AS ESTADO            ,
		        ISNULL(CODIGONOMECIDADE  , '')  AS CODIGONOMECIDADE  ,
		        ISNULL(BAIRRO            , '')  AS BAIRRO            ,
		        ISNULL(CEP               , '')  AS CEP               ,
		        ISNULL(CNPJ              , '')  AS CNPJ              , 
		        ISNULL(NOMECONTADOR      , '')  AS NOMECONTADOR      ,
		        ISNULL(INSCRICAOESTADUAL , '')  AS INSCRICAOESTADUAL , 
		        LOWER(ISNULL(EMAIL       , '')) AS EMAIL             ,
		        ISNULL(CODIGOVENDEDORESP , '')  AS CODIGOVENDEDORESP ,    
		        ISNULL(CESP_DDD          , '')  AS CESP_DDD          ,
		        ISNULL(TELEFONE          , '')  AS TELEFONE          		
        FROM T_CLIENTENOVO_SOBEL
        WHERE SEQUENCIA = %Exp:nSeq%
        AND DATAINTEGRACAOERP IS NULL 
		AND CODIGOERP IS NULL
				
    EndSQL

    While !(AFV->(EoF()))

        aResult :={{"A1_LOJA"    ,'01'                   ,Nil},;
	               {"A1_NOME"    ,AFV->RAZAOSOCIAL       ,Nil},;
	               {"A1_ZZCNOME" ,AFV->RAZAOSOCIAL       ,Nil},;
	               {"A1_PESSOA"  ,"J"				     ,Nil},; 
	               {"A1_NREDUZ"  ,AFV->NOMEREDUZIDO	     ,Nil},;
	               {"A1_TIPO"    ,"F"	                 ,Nil},;	
	               {"A1_END"     ,AFV->ENDERECO			 ,Nil},;
	               {"A1_EST"     ,AFV->ESTADO    		 ,Nil},;
	               {"A1_COD_MUN" ,AFV->CESP_CODIGOIBGE	 ,Nil},;						
    	           {"A1_MUN"     ,AFV->CODIGONOMECIDADE	 ,Nil},;
	               {"A1_BAIRRO"  ,AFV->BAIRRO			 ,Nil},;
	               {"A1_CEP"   	 ,AFV->CEP				 ,Nil},;
	               {"A1_PAIS"  	 ,"105"					 ,Nil},;
	               {"A1_CGC"   	 ,AFV->CNPJ				 ,Nil},;
	               {"A1_CONTATO" ,AFV->NOMECONTADOR		 ,Nil},;
	               {"A1_INSCR"   ,AFV->INSCRICAOESTADUAL ,Nil},;
	               {"A1_EMAIL"   ,AFV->EMAIL			 ,Nil},;
	               {"A1_NATUREZ" ,"1002001"				 ,Nil},;
	               {"A1_VEND"    ,AFV->CODIGOVENDEDORESP ,Nil},;
	               {"A1_CONTA"   ,"11210001"          	 ,Nil},;
	               {"A1_TPFRET"  ,"C"					 ,Nil},;
	               {"A1_CODPAIS" ,"01058"				 ,Nil},;
	               {"A1_XREGIAO" ,"999"					 ,Nil},;
	               {"A1_RISCO"   ,"E"					 ,Nil},;
	               {"A1_TABELA"  ,"999"					 ,Nil},;
	               {"A1_DDD"     ,AFV->CESP_DDD			 ,Nil},;
				   {"A1_MSBLQL"  ,"1"				     ,Nil},; 
	               {"A1_TEL"     ,AFV->TELEFONE			 ,Nil},;
	               {"A1_ZZBOL"   ,"N"					 ,Nil}} 

			AFV->(DbSkip())		
    End

	AFV->(DbCloseArea())
	RestArea(aArea)		

Return aResult


//-------------------------------------------------------------------
/*/{Protheus.doc} recSA1
	Chama MSExecAuto para MATA030 (cadastro de cliente)
@author  Ademilson Nunes / Elvis Kinuta
@param aResult, array, matriz SA1
@param cUniFat, caracter, código da empresa (unidade de faturamento)
	   01 - SOBEL | 02 - JMT | 04 - 3F	   
@since   14/03/2019
@version 12.1.17
/*/
//-------------------------------------------------------------------
Static Function recSA1( aResult, cUniFat )

	Private lMsErroAuto    := .F.	
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private aError      := {}
	Private cRet        := ''
	Private nX          := 0
	Private oLog 
	
		MSExecAuto( {|x,y| Mata030(x,y)}, aResult, 3 )

		If ! lMsErroAuto

			ConfirmSx8()	
			// Recebe cnpj do cliente em sua posição dentro do array (Linha 14 - Coluna 02)
			cCNPJ   := cValToChar(aResult[14][2])	

			// Grava A1_COD do registro na tabela T_CLIENTENOVO_SOBEL
			setA1Cod( cCNPJ, getA1Cod(cCNPJ) )						
			//Enviar e-mail

		Else

			RollbackSx8()
			//MostraErro()
             
			// Cria arquivo de Log 
			oLog   := FCreate(cFileLog)

			// recebe array com erros durante a tentativa de execução da MATA030 
			aError := GetAutoGRLog()

			cRet   := 'LOG	- ' + DtoC(dDataBase) + " " + Time() + Chr(13) + Chr(10) 
			cRet   := 'ERRO - EMPRESA -' + cUniFat + Chr(13) + Chr(10)	

			// Desmonta array de erros linha a linha em uma string
            For nX := 1 To Len(aError) 

                cRet += aError[nX] + Chr(13) + Chr(10)

            Next nX

			/* Escreve log de erros */ 
			FWrite(oLog,  cRet)	

		
		EndIf

Return Nil
