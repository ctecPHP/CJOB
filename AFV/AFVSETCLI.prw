#include 'totvs.ch'
#include 'tbiconn.ch'
/*/{Protheus.doc} AFVSETCLI
        Cadastro de novos clientes vindos do AFV Acácia 
    @type  Function
    @author Ademilson Nunes / Elvis Kinuta
    @since 14/03/20219
    @version 12.1.17
/*/
/*  TODO_LIST 
    1 - Subir ambiente 01 (sobel) - ok
    2 - Executar função que retorne array registros de novos clientes 
    3 - Verificar unidade de faturamento do registro presente no array
    4 - Executar função que monte ambiente de acordo com a unidade de faturamento 
    5 - Preparar array para ExecAuto
    6 - Executar ExecAuto na rotina MATA030
    7 - Disparar e-mail para o financeiro/crédito notificando sobre o 'pré cadastro' do cliente
        detalhar no e-mail os dados básicos do cadastro bem como seu codigo e unidade de faturamento.
    8 - Criar arquivo de log detalhando toda operação, em caso de log de erro 
        disparar e-mail para o departamento de TI com o conteúdo do log. 
		//fWrite( cLogObj, AsString(aReg) + " Tamanho " + cValToChar(Len(aReg[1]))) 
*/
User Function AFVSETCLI()
	Private aReg      := {}
	Private aResult   := {}
	Private cFileLog  := "ACACIA"+"\debug.log
	Private cLogObj   := FCreate(cFileLog)
	Private nX        := 0
	Private cUnidFat  := ''
	Private cSeq      := ''


	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO "FAT"

		//coleta novos clientes 
		aReg := findNewCli() 		

	RESET ENVIRONMENT

		//Percorre registros 
		For nX:= 1 to Len(aReg[1])
			cSeq   	 := cValToChar(aReg[1][nX])
			cUnidFat := cValToChar(aReg[2][nX])

			aResult  := getNewCli( cUnidFat, cSeq )
			recSA1( aResult, cUnidFat )
		Next

		
Return Nil


/*/{Protheus.doc} findNewCli
    (long_description)
    @type  Static Function
    @author  Ademilson Nunes / Elvis Kinuta
    @since date
    @version version
    @param cUnidFat, caracter, unidade de faturamento 01 - Sobel | 02 - JMT | 04 - 3F
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
		AAdd( aReg, AllTrim(cValToChar(AFV->SEQUENCIA) )) 
		AAdd( aEmp, AllTrim(AFV->CODIGOUNIDFAT) )
		AFV->(DbSkip())
	End

	AAdd( aResult, aReg )
	AAdd( aResult, aEmp )

	AFV->(DbCloseArea())
	RestArea(aArea)	    

Return aResult


/*/{Protheus.doc} getNewCli
    (long_description)
    @type  Static Function
    @author  Ademilson Nunes / Elvis Kinuta
    @since date
    @version version
    @param cUnidFat, caracter, unidade de faturamento 01 - Sobel | 02 - JMT | 04 - 3F
	@param cSeq, caracter, código do cliente na tabela intermédiaria (pré cadastro)
    @return return, return_type, return_description
    /*/
Static Function getNewCli( cUnidFat, cSeq )
  	Local aArea   := GetArea()
	Local aResult := {}

	PREPARE ENVIRONMENT EMPRESA cUnidFat FILIAL '01' MODULO "FAT"

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
        WHERE CODIGOUNIDFAT = %Exp:cUnidFat%
		AND SEQUENCIA = %Exp:cSeq%
        AND DATAINTEGRACAOERP IS NULL 		
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
    End

	AFV->(DbCloseArea())
	RestArea(aArea)		
	RESET ENVIRONMENT       
Return aResult


//-------------------------------------------------------------------
/*/{Protheus.doc} recSA1
	Chama MSExecAuto para MATA030 (cadastro de cliente)
@author  Ademilson Nunes / Elvis Kinuta
@since   14/03/2019
@version 12.1.17
/*/
//-------------------------------------------------------------------
Static Function recSA1( aDados, cUnidFat )
	Private lMsErroAuto := .F.

	PREPARE ENVIRONMENT EMPRESA cUnidFat FILIAL '01' MODULO "FAT"

		MSExecAuto( {|x,y| Mata030(x,y)}, aDados, 3 )

		If ! lMsErroAuto
			ConfirmSx8()			
			//SFACALOG(2) //GraVa Log	
			lOk	:= .T.
		Else
			RollbackSx8()
			//SFACALOG(1) //GraVa Log
	
		EndIf

	RESET ENVIRONMENT	

Return Nil