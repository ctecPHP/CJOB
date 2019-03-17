#include 'totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} TSTMAIL
description
@author  Ademilson Nunes
@since   16/03/2019
@version 12.1.17
/*/
//-------------------------------------------------------------------
User function TSTMail()    
    Local cMensagem := 'Teste de e-mail'
    Local cPara     := 'ctec.php@gmail.com'
    Local cAssunto  := 'Teste Env Protheus'
    Local aArquivos := ''
    Local aTables   := {"SA1"}
	local aResult := {}

	
    aResult :=    {{"A1_LOJA"    ,'01'                    ,Nil},;
	               {"A1_NOME"    ,'AFV->RAZAOSOCIAL'      ,Nil},;
	               {"A1_ZZCNOME" ,'AFV->RAZAOSOCIAL'      ,Nil},;
	               {"A1_PESSOA"  ,"J"				      ,Nil},; 
	               {"A1_NREDUZ"  ,'AFV->NOMEREDUZIDO'	  ,Nil},;
	               {"A1_TIPO"    ,"F"	                  ,Nil},;	
	               {"A1_END"     ,'AFV->ENDERECO'		  ,Nil},;
	               {"A1_EST"     ,'AFV->ESTADO'    		  ,Nil},;
	               {"A1_COD_MUN" ,'AFV->CESP_CODIGOIBGE'  ,Nil},;						
    	           {"A1_MUN"     ,'AFV->CODIGONOMECIDADE' ,Nil},;
	               {"A1_BAIRRO"  ,'AFV->BAIRRO'			  ,Nil},;
	               {"A1_CEP"   	 ,'AFV->CEP'			  ,Nil},;
	               {"A1_PAIS"  	 ,"105"					  ,Nil},;
	               {"A1_CGC"   	 ,'AFV->CNPJ'			  ,Nil},;
	               {"A1_CONTATO" ,'AFV->NOMECONTADOR'	  ,Nil},;
	               {"A1_INSCR"   ,'AFV->INSCRICAOESTADUAL',Nil},;
	               {"A1_EMAIL"   ,'AFV->EMAIL'			  ,Nil},;
	               {"A1_NATUREZ" ,"1002001"				  ,Nil},;
	               {"A1_VEND"    ,'AFV->CODIGOVENDEDORESP',Nil},;
	               {"A1_CONTA"   ,"11210001"          	  ,Nil},;
	               {"A1_TPFRET"  ,"C"					  ,Nil},;
	               {"A1_CODPAIS" ,"01058"				  ,Nil},;
	               {"A1_XREGIAO" ,"999"					  ,Nil},;
	               {"A1_RISCO"   ,"E"					  ,Nil},;
	               {"A1_TABELA"  ,"999"					  ,Nil},;
	               {"A1_DDD"     ,'AFV->CESP_DDD'		  ,Nil},;
				   {"A1_MSBLQL"  ,"1"				      ,Nil},; 
	               {"A1_TEL"     ,'AFV->TELEFONE'		  ,Nil},;
	               {"A1_ZZBOL"   ,"N"					  ,Nil}} 

    RpcSetType(3) 
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )
        u_FBEMail(cPara, cAssunto, mountMsg( aResult, '02' ))
    RpcClearEnv()    

Return Nil


Static Function getNomeVen( cCodVen )

	Local aArea   := GetArea()
	Local cResult := ''

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


Static Function mountMsg( aResult, cUniFat )
	
	Local cMsg      := ''
	Local cEmp      := getEmpName( cUniFat )	
	Local cCNPJ     := cValtoChar(aResult[14][02])
	//Local cCodSA1   := getA1Cod( cCNPJ )
	Local cCodSA1   := ''
    Local cCodVen   := cValToChar(aResult[19][02])
	//Local cNomeVen := getNomeVen(cCodVen)
	Local cNomeVen  := ''
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
	cMsg += '<meta charset="UTF-8">'
	cMsg += '<title></title>'
    cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<table border="1">'
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