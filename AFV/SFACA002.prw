#include 'totvs.ch'
/*/{Protheus.doc} SFACA002
        Cadastra novos clientes vindos do AFV 'Acacia' 
    @type  Function
    @author Ademilson Nunes / Elvis Kinuta
    @since 14/03/2019
    @version 12.1.17
/*/
User Function SFACA002()

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
	
	//Prepara ambiente SOBEL para coletar possíveis novos registros 
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
				recSA1( aResult, cUnidFat, nSeq ) 	

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
@since   18/03/2019
@version 12.1.17
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
@author  Ademilson Nunes
@since   15/03/2019
@version 12.1.17
@param cEmp, caracter, código da empresa 01 - SOBEL | 02 - JMT | 04 - 3F
/*/
//-------------------------------------------------------------------
Static Function prepEnv( cEmp )

	RpcSetType(3) 
	RpcSetEnv( cEmp, cFil, cUser, cPsw, "FAT", "", aTables, , , ,  )

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} closeEnv
description
@author  Ademilson Nunes 
@since   15/03/2019
@version 12.1.17
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
@param nSeq, numérico, PK T_CLIENTENOVO_SOBEL	   
@since   14/03/2019
@version 12.1.17
/*/
//-------------------------------------------------------------------
Static Function recSA1( aResult, cUniFat, nSeq  )

	Private lMsErroAuto    := .F.	
	Private lMsHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private aError      := {}
	Private cRet        := ''
	Private cRetHtml    := ''
	Private nX          := 0
	Private oLog 
	Private cEmailTI    := 'assistente_ti@sobelsuprema.com.br;jcsilva@sobelsuprema.com.br'
	Private cEmailFin   := 'assistente_ti@sobelsuprema.com.br;admvendas@sobelsuprema.com.br;jcsilva@sobelsuprema.com.br' //Coletar e-mail da Adriana
	
		MSExecAuto( {|x,y| Mata030(x,y)}, aResult, 3 )

		If ! lMsErroAuto

			ConfirmSx8()	
			// Recebe cnpj do cliente em sua posição dentro do array (Linha 14 - Coluna 02)
			cCNPJ   := cValToChar(aResult[14][2])	

			// Grava A1_COD do registro na tabela T_CLIENTENOVO_SOBEL
			setA1Cod( cCNPJ, getA1Cod(cCNPJ) )						
			//Enviar e-mail
			u_FBEMail( cEmailFin, 'Novo Cliente cadastrado', mountMsg( aResult, cUniFat ))

		Else

			RollbackSx8()
			//MostraErro()
             
			// Cria arquivo de Log 
			oLog   := FCreate(cFileLog)

			// recebe array com erros durante a tentativa de execução da MATA030 
			aError := GetAutoGRLog()

			cRet   := 'LOG	- ' + DtoC(dDataBase) + " " + Time() + Chr(13) + Chr(10) 
			cRet   += 'ERRO - EMPRESA -' + cUniFat + Chr(13) + Chr(10)	

			cRetHtml :=	'LOG	- ' + DtoC(dDataBase) + " " + Time() + "<br>"
			cRetHtml += 'ERRO - EMPRESA -' + cUniFat + "<br>"

			// Desmonta array de erros linha a linha em uma string
            For nX := 1 To Len(aError) 

                cRet     += aError[nX] + Chr(13) + Chr(10)
				cRetHtml +=	aError[nX] + '<br>'		

            Next nX

			/* Escreve log de erros */ 
			FWrite(oLog,  cRet)	

			/* Envia e-mail de log para o TI */ 			
			//Verifica se MSGIMPORTACAO do registro está NULL
			If getMSGCli( nSeq ) <> ''

				setMSGCli( nSeq, cRet )
				u_FBEMail( cEmailTI, 'Error-Log-AFV',  cRetHtml )

			EndIf
			
		
		EndIf

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} setMSGCli
	Grava MSGIMPORTACAO na tabela T_CLIENTENOVO_SOBEL
@author  Ademilson Nunes
@since   18/03/2019
@version 12.1.17
@param nSeq, númerico, PK T_CLIENTENOVO_SOBEL
@param cMsg, caracter, mensagem a ser gravada no campo
/*/
//-------------------------------------------------------------------
Static Function setMSGCli( nSeq, cMsg )
	
	Local cQry := ""
		  cQry := " UPDATE T_CLIENTENOVO_SOBEL "
		  cQry += " SET MSGIMPORTACAO ='" + cMsg + "'"
		  cQry += " WHERE SEQUENCIA = " + nSeq

   TCSqlExec(cQry)

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

		SELECT MSGIMPORTACAO
		FROM T_CLIENTENOVO_SOBEL
		WHERE SEQUENCIA = %Exp:nSeq%

	EndSQL

	While !(AFV->(EoF()))

		cResult := AFV->MSGIMPORTACAO
	    AFV->(DbSkip())

	End

	AFV->(DbCloseArea())
	RestArea(aArea)

Return cResult


//-------------------------------------------------------------------
/*/{Protheus.doc} getNomeVen
	Retorna Nome do vendedor a partir do código (A3_COD)
@author  Ademilson Nunes
@since   15/03/2019
@version 12.1.17
@param cCodVen, caracter, código do vendedor (A2_COD)
@return cResult, caracter, nome do vendedor (A3_NOME)
/*/
//-------------------------------------------------------------------
Static Function getNomeVen( cCodVen )

	Local aArea   := GetArea()
	Local cResult := ''

	cCodVen := AllTrim(cCodVen)

	BeginSQL Alias 'TBL'

		SELECT A3_NOME 
		FROM %table:SA3% SA3 
		WHERE 
		A3_COD = %Exp:cCodVen%
		AND SA3.%notDel%	

	EndSQL

	While !TBL->(EoF())

		cResult := AllTrim(cValtoChar( TBL->A3_NOME ))
		TBL->(DbSkip())

	End

	TBL->(DbCloseArea())
	RestArea(aArea)	  

Return cResult

//-------------------------------------------------------------------
/*/{Protheus.doc} mountMsg
	Monta conteúdo da msg em HTML para envio de e-mail
@author  Ademilson Nunes
@since   17/03/2019
@version 12.1.17
@param aResult, array, coleção de dados com registro a ser armazenado em SA1
@param cUniFat, caracter, código da empresa 01 - SOBEL | 02 - JMT | 04 - 3F	   
/*/
//-------------------------------------------------------------------
Static Function mountMsg( aResult, cUniFat )
	
	Local cMsg      := ''
	Local cEmp      := getEmpName(cUniFat)	
	Local cCNPJ     := cValtoChar(aResult[14][02])
	Local cCodSA1   := getA1Cod(cCNPJ)
    Local cCodVen   := cValToChar(aResult[19][02])
	Local cNomeVen  := getNomeVen(cCodVen)
	Local cRzSocial := cValToChar(aResult[02][02])
	Local cNomeRed  := cValToChar(aResult[05][02])
	Local cIE       := cValToChar(aResult[16][02])
	Local cEnder    := cValToChar(aResult[07][02])
	Local cUF       := cValToChar(aResult[08][02])
	Local cCidade   := cValToChar(aResult[10][02])
	Local cBairro   := cValToChar(aResult[11][02])
	Local cCep      := cValToChar(aResult[12][02])
	Local cEmail    := cValToChar(aResult[17][02])
	Local cTel      := cValToChar(aResult[26][02]) + " " + cValToChar(aResult[28][02])        

	cMsg := '<!DOCTYPE html>'
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">'
	cMsg += '<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>'
	cMsg += '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>'
	cMsg += '<title>Relatorio</title>'
    cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<table class="table">'
	cMsg += '<tr>'
	cMsg += '<td colspan="2" align="center"><b>Novo cliente cadastrado</b></td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Empresa</b></td>'
	cMsg +=	'<td>' + cEmp + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Cod.Protheus</b></td>'
	cMsg += '<td>' + cCodSA1 + '</td>'	
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Cod. Vend.</b></td>'
	cMsg += '<td>' + cCodVen + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Nome Vend.</b></td>'
	cMsg += '<td>' + cNomeVen + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg +=' <td><b>Razao Social</b></td>'
	cMsg += '<td>' + cRzSocial + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Nome Reduz.</b></td>'
	cMsg += '<td>' + cNomeRed + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>CNPJ</b></td>'
	cMsg += '<td>' + cCNPJ + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>IE</b></td>'
	cMsg += '<td>' + cIE + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Ender.</b></td>'
	cMsg += '<td>' + cEnder + '</td>'
	cMsg +=	'</tr>'
	cMsg += '<tr>'
	cMsg +=	'<td><b>UF</b></td>'
	cMsg += '<td>' + cUF + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Cidade</b></td>'
	cMsg += '<td>' + cCidade + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Bairro</b></td>'
	cMsg += '<td>' + cBairro + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>CEP</b></td>'
	cMsg += '<td>' + cCep + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>E-mail</b></td>'
	cMsg += '<td>' + cEmail + '</td>'
	cMsg += '</tr>'
	cMsg += '<tr>'
	cMsg += '<td><b>Tel.:</b></td>'
	cMsg += '<td>' + cTel + '</td>'
	cMsg += '</tr>'					
	cMsg += '</table>'
    cMsg += '</body>'
    cMsg += '</html>'

Return cMsg

//-------------------------------------------------------------------
/*/{Protheus.doc} getEmpName
	Retorna 'Nome unidade de faturamento'
@author  Ademilson
@since   18/03/2019
@version 12.1.17
@param cUniFat, caracter, código unidade de faturamento.
@return cEmp, caracter, nome empresa.
/*/
//-------------------------------------------------------------------
Static Function getEmpName( cUniFat )

	Local cEmp := ''

	If cUniFat == '01'

		cEmp := 'SOBEL'

	ElseIf cUniFat == '02'
		
		cEmp := 'JMT'
	ElseIf cUniFat == '04'	

		cEmp := '3F'
	Else

		cEmp := ''

	EndIf	

Return cEmp