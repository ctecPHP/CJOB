#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch" 
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FKXFUN    ºAutor  ³Carlos R. Moreira   º Data ³  05/14/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes comuns no Cliente                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Carlos R. Moreira   º Data ³  03/19/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o grupo de Perguntas                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ValidPerg(cPerg,aRegs)
	Local aArea := GetArea()
	Local i,j
	dbSelectArea("SX1")
	dbSetOrder(1)

	If len(Alltrim(cPerg)) < 10 
		cPerg := Alltrim(cPerg)+Space(10 - Len(Alltrim(cPerg)))
	EndIf


	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CABREL    ºAutor  ³Carlos R.Moreira    º Data ³  05/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Emite o cabecalho padrao para os relatorios customizados    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Escola Graduada                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function CabRel(aTitulo,nForma,oPrn,nPag,cProg)
	Local cBitMap:= FisxLogo("1") 

	oArial06Neg  :=  TFont():New( "Arial",,06,,.T.,,,,,.F. )

	If nForma == 1   //Paisagem

		Titulo := aTitulo[1]
		oPrn:Box( 050,  100, 300, 300 )
		oPrn:SayBitmap( 100,120,cBitMap,150,150 )
		oPrn:Box( 050,  301, 300,2500 )
		oPrn:Box( 050, 2501, 300,3300 )

		nCol :=  1610 - ( (Len(Alltrim(aTitulo[2])) / 2 ) * 20 )
		oPrn:Say(  80,  nCol, aTitulo[2],oFont2,100 )

		nCol :=  1610 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
		oPrn:Say( 150,  nCol, aTitulo[1],oFont2,100 )

		nCol :=  1610 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
		oPrn:Say( 220,  nCol, aTitulo[3],oFont2,100 )

		//	oPrn:Say( 150, 700, Titulo ,oFont3,100 )

		oPrn:Say( 090, 2720, "Pagina  :       "+StrZero(nPag,3),oFont12,100 )
		oPrn:Say( 150, 2720, "Emissao : "+Dtoc(Date())   ,oFont12,100 )
		oPrn:Say( 210, 2720, "Hora    : "+Time()   ,oFont12,100 )
		//	oPrn:Say( 270, 2920, cProg  ,oArial06Neg,100 )

	Else

		oPrn:Box( 050, 100, 300,2300 )
		oPrn:SayBitmap( 100,180,cBitMap,220,180 )
		oPrn:Line( 050, 550, 300, 550 )
		oPrn:Line( 050, 1800, 300, 1800 )

		nCol :=  1125 - ( (Len(Alltrim(aTitulo[2])) / 2 ) * 20 )
		oPrn:Say(  80,  nCol, aTitulo[2],oFont2,100 )

		nCol :=  1125 - ( (Len(Alltrim(aTitulo[1])) / 2 ) * 20 )
		oPrn:Say( 150,  nCol, aTitulo[1],oFont2,100 )

		nCol :=  1125 - ( (Len(Alltrim(aTitulo[3])) / 2 ) * 20 )
		oPrn:Say( 220,  nCol, aTitulo[3],oFont2,100 )

		oPrn:Say( 80,  1820, "Emissão : "+Dtoc(dDataBase),oFont3,100 )

		oPrn:Say( 150, 1820, "Página  : "+StrZero(nPag,3),oFont3,100 )

		oPrn:Say( 220, 1820, "Hora  : "+Time(),oFont3,100 )

		oPrn:Say( 270, 2020, cProg ,oArial06Neg ,100 )	
	EndIf

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FKXFUN    ºAutor  ³Microsiga           º Data ³  10/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AceVarQry()

	Local cFilterUser := ""
	If !Empty(aReturn[7])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Filtro das Notas de Devolucao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cFilterUser := aReturn[7]
		//	cFilterUser := STRTRAN (cFilterUser,"D2","D1" )
		cFilterUser := STRTRAN (cFilterUser,".And."," And " )
		cFilterUser := STRTRAN (cFilterUser,".and."," And " )
		cFilterUser := STRTRAN (cFilterUser,".Or."," Or ")
		cFilterUser := STRTRAN (cFilterUser,".or."," Or ")
		cFilterUser := STRTRAN (cFilterUser,"=="," = ")
		cFilterUser := STRTRAN (cFilterUser,'"',"'")
		cFilterUser := STRTRAN (cFilterUser,'Alltrim',"LTRIM")
		cFilterUser := STRTRAN (cFilterUser,'$',"Like %")
		cFilterUser := STRTRAN (cFilterUser,"DTOS","")
		cFilterUser := STRTRAN (cFilterUser,"dtos","")
		cFilterUser := STRTRAN (cFilterUser,"dTos","")
		cFilterUser := STRTRAN (cFilterUser,"dToS","")
		cFilterUser := STRTRAN (cFilterUser,"!="," <> " )

		//	cFilterUser := STRTRAN (cFilterUser,"CLIENTE","FORNECE" )

	EndIf 

Return cFilterUser   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³Fc021ProcEx³ Autor ³ Claudio D. de Souza  ³ Data ³ 25-04-2005 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Processa a exportacao da planilha de trabalho para o Excel.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³FINC021                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Run_Excel(aDadosExcel,nCol)
	LOCAL cDirDocs   := MsDocPath() 
	Local aStru		:= {}
	Local cArquivo := CriaTrab(,.F.)
	Local cPath		:= AllTrim(GetTempPath())
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX

	ProcRegua(Len(aDaDosExcel))

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle > 0


		For nX := 1 to Len(aDadosExcel)

			IncProc("Aguarde! Gerando arquivo de integração com Excel...") // 
			cBuffer := ""
			For nY := 1 to nCol  //Numero de Colunas do Vetor

				cBuffer += aDadosExcel[nX,nY] + ";"

			Next 
			fWrite(nHandle, cBuffer+cCrLf ) // Pula linha

		Next

		IncProc("Aguarde! Abrindo o arquivo...") // 

		fClose(nHandle)

		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

		If ! ApOleClient( 'MsExcel' ) 
			MsgAlert( 'MsExcel nao instalado' ) //
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		MsgAlert( "Falha na criação do arquivo" ) // 
	Endif	

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ 	Env_Email   ³ Autor ³ Carlos R. Moreira³ Data ³ 28/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que envia email                            		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cEmailTo:	Email do Destinatario.                       ³±±
±±³		     ³ cEmailCC:	Outras Contas para mandar Copia do email.    ³±±
±±³		     ³ cAssunto:	Assunto do Email.							 ³±±
±±³		     ³ cMensagem:	Mensagem do Corpo do email.                  ³±±
±±³		     ³ cAttach:		Arquivos a serem attachados no email.    	 ³±±
±±³			 ³ cChave:		Filial + Matricula do funcionario.  		 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generica                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Env_Email(cEmailTo,cEmailCC,cAssunto,cMensagem,cAttach,cChave)

	Local aSaveArea		:= GetArea()
	Local lOk			:= .F.		// Variavel que verifica se foi conectado OK
	Local lSendOk		:= .F.		// Variavel que verifica se foi enviado OK
	Local cNome			:= ""
	Local cMailConta	:=GETMV("MV_EMCONTA")
	Local cMailServer	:=GETMV("MV_RELSERV")
	Local cMailSenha	:=GETMV("MV_EMSENHA")
	Local nErro			:= 0

	cEmailTo	:= If(cEmailTo 	== Nil, "", cEmailTo)
	cEmailCC	:= If(cEmailCC 	== Nil, "", cEmailCC)
	cAssunto	:= If(cAssunto 	== Nil, "", cAssunto)
	cMensagem	:= If(cMensagem	== Nil, "", cMensagem)
	cAttach		:= If(cAttach 	== Nil, "", Alltrim(cAttach))
	cChave		:= If(cChave	== Nil, "", cChave)

	//Verifica se existe o SMTP Server
	If 	Empty(cMailServer)
		nErro := 1
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

	//Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		nErro := 2
		RestArea(aSaveArea)
		Return(nErro)
	EndIf

	//Verifica se existe a Senha
	If 	Empty(cMailSenha) 
		nErro := 3
		RestArea(aSaveArea)
		Return(nErro)
	EndIf                                              

	//Verifica se existe email do Destinatario
	If 	Empty(cEmailTo)
		nErro := 4
		RestArea(aSaveArea)
		Return(nErro)
	EndIf      

	// Envia e-mail com os dados necessarios
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		If 	lOk                                                                          
			SEND MAIL 	FROM cMailConta;
			TO cEmailTo;
			BCC cEmailcc;					
			SUBJECT cAssunto;
			BODY cMensagem;  
			ATTACHMENT cAttach;					
			RESULT lSendOk 
			If !lSendOk
				//Erro no Envio do e-mail
				nErro := 5
			EndIf
			DISCONNECT SMTP SERVER
		Else
			//Erro na conexao com o SMTP Server
			nErro := 5
		EndIf
	EndIf                   

	RestArea(aSaveArea)

Return nErro   


//Funcoes para envio de email
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QNCXRMAIL  ³ Autor ³ Cicero Cruz           ³ Data ³ 26/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de envio do email generica de Relatório. 			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QNCXRMAIL()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAQNC				                 					    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function  QNCXRMAIL(aRel) 

	Local aArqAux := {}   
	Local aAttach := {}  
	Local aDados  := U_QNCXRTO() 
	Local cBody   := "" 
	Local cAttach := "" 
	Local cSubject := IIF(aRel[1,3]=="","",aRel[1,3])
	Local aUsrMat := U_QA_USUARIO() 
	Local nX      := 0 
	Local nY      := 0 
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | Valida digitação dos destinatarios. |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(aDados[1])                                     
		Return
	EndIF	
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// |Gerando Corpo do Email com os Relatorios gerados.   |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aDados[2])
		cBody := Alltrim(aDados[2])
		cBody += CHR(13)+CHR(10)+CHR(13)+CHR(10)
	EndIF
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// |Anexa  arquivos                   |
	// |       aRel{Path,Arquivo}         |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX:=1 to Len(aRel)      
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		// | Verifico o arquivo.                 |
		// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aArqAux := Directory(aRel[nX,1]+aRel[nX,2]+"*.jpg") 

		For nY:=1 to Len(aArqAux)      
			AADD(aAttach,{aArqAux[nY,1],aRel[nX,3]}) 
			If !Empty(cAttach)	
				cAttach +=";"
			EndIf
			cAttach +=cStartPath+aArqAux[nY,1]
		Next nY
	Next nX

	aArqAux := {}
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | Monta dados para envio do email.    |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aArqAux,{" - " + cSubject,cBody,cAttach}) 
	aUsuarios := {{"",aDados[1],aArqAux,"2"} }
	U_QaEnvMail(aUsuarios,,,,aUsrMat[5],"2" )  // "2"   

	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | Deleta arquivos JPEG gerados pelos relatorios. |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nY:=1 to Len(aAttach)
		FErase( cStartPath+aAttach[nY,1] )
	Next nY 

Return               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QAEnvMail ³ Autor ³ Aldo Marini Junior    ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que envia e-mail de acordo com array                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QAEnvMail(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os dados de envio (To,Subject,Body,      ³±±
±±³          ³         Attachment)                                        ³±±
±±³          ³ ExpC1 = Caracter contendo conta de acesso ao servidor      ³±±
±±³          ³ ExpC2 = Caracter contendo o endereco do servidor           ³±±
±±³          ³ ExpC3 = Caracter contendo senha de acesso ao servidor      ³±±
±±³          ³ ExpC4 = Caracter contendo a conta do Usuario logado        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ lResult = Logico retornando se houve algum erro no envio   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QAEnvMail(aUsuarios,cMailConta,cMailServer,cMailSenha,cSendConta,cTipoemail)
	Local lResult	:= .F.
	Local aRetUser := {}
	Local nAtConta
	Default cMailConta  := AllTrim(GETMV("MV_RELACNT"))
	Default cMailServer := AllTrim(GETMV("MV_RELSERV"))
	Default cMailSenha  := AllTrim(GETMV("MV_RELPSW"))
	Default cSendConta  := "SIGA"+cModulo
	Default cTipoemail	:= "1" //1=Sistemas 2=Usuario

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a conta de email do usuario esta com mais de uma e considera apenas ³
	//³ a primeira para conectar e enviar email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ";" $ cSendConta
		nAtConta := AT(";",cSendConta)
		cSendConta := SubStr(cSendConta,1,nAtConta-1)
	Endif

	If Len(aUsuarios) == 0
		Return(.F.)
	Endif

	IF cTipoemail=="2"  //Tipo 2=Usuario
		If cSendConta == ("SIGA"+cModulo) .Or. Empty(AllTrim(cSendConta))
			PswOrder(1)
			PswSeek(__CUSERID)
			aRetUser := PswRet(1)
			If !Empty(aRetUser[1][14])
				cSendConta := AllTrim(aRetUser[1][14])
			Else                      
				cSendConta := GetMV("MV_EMCONTA")
				IF Empty(AllTrim(cSendConta))    
					cSendConta := "SIGA"+cModulo+"@PROTHEUS"
				Endif	
			EndIf
		Endif
	Else				//Tipo 1=Sistemas
		cSendConta := GetMV("MV_EMCONTA")
		IF Empty(AllTrim(cSendConta))                
			cSendConta := "SIGA"+cModulo+"@PROTHEUS"
		Endif		
	Endif	

	If Empty(AllTrim(cMailConta))
		cMailConta :=AllTrim(GETMV("MV_RELACNT"))
	Endif

	If Empty(AllTrim(cMailServer))
		cMailServer:=AllTrim(GETMV("MV_RELSERV"))
	Endif

	If Empty(AllTrim(cMailSenha))
		cMailSenha :=AllTrim(GETMV("MV_RELPSW"))
	Endif

	LjMsgRun(OemToAnsi("Enviando e-Mail para os Usuarios..."),OemtoAnsi("Aguarde"),{||U_QARunMail(aUsuarios,cMailConta,cMailServer,cMailSenha,@lResult,cSendConta)})  // ### "Aguarde"

Return(lResult)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QARunMail ³ Autor ³ Aldo Marini Junior    ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que envia e-mail Mostrando Msg de Processamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QARunMail(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com os dados de envio (To,Subject,Body,      ³±±
±±³          ³         Attachment)                                        ³±±
±±³          ³ ExpC1 = Caracter contendo conta de acesso ao servidor      ³±±
±±³          ³ ExpC2 = Caracter contendo o endereco do servidor           ³±±
±±³          ³ ExpC3 = Caracter contendo senha de acesso ao servidor      ³±±
±±³          ³ ExpL1 = Logical  indicando Erro na Conexao ao Servidor     ³±±
±±³          ³ ExpC4 = Caracter contendo a conta do Usuario logado        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³ lResult = Logico retornando se houve algum erro no envio   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QARunMail(aUsuarios,cMailConta,cMailServer,cMailSenha,lResult,cSendConta)
	Local nA := 1
	Local nI := 1
	Local cError	:= ""
	Local lAuth 	:= GetMv("MV_RELAUTH",,.F.)
	Local lMsgError	:= GetMv("MV_QMSGERM", .T., .T.)

	If Empty(cSendConta)
		cSendConta := If(Empty(GetMV("MV_RELFROM",.F.,"")),cSendConta,AllTrim(GetMV("MV_RELFROM")))
	EndIf  

	lResult	:= .F.

	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)

		For nI :=1 to Len(aUsuarios)
			If !Empty(aUsuarios[nI,2])
				If ! lResult
					// Envia e-mail com os dados necessarios
					CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lResult

					// Autenticacao da conta de e-mail 
					If lResult .And. lAuth
						lResult := MailAuth(cMailConta,cMailSenha)
						If !lResult
							lResult := QAGetMail() // Funcao que abre uma janela perguntando o usuario e senha para fazer autenticacao
						EndIf
						If !lResult
							//Erro na conexao com o SMTP Server
							If lMsgError
								GET MAIL ERROR cError
								MsgInfo(cError,OemToAnsi("Erro de Autenticacao")) // "Erro de Autenticacao"
							Endif
							Return Nil
						Endif
					Else
						If !lResult
							//Erro na conexao com o SMTP Server
							If lMsgError
								GET MAIL ERROR cError
								MsgInfo(cError,OemToAnsi("Erro de Conexao")) // "Erro de Conexao"
							Endif
							Return Nil
						Endif
					EndIf
				Endif

				If lResult
					For nA := 1 to Len(aUsuarios[nI,3])
						If !lResult
							Exit
						Endif

						SEND        MAIL  ;
						FROM        cSendConta ;
						TO          aUsuarios[nI,2] ;
						SUBJECT     "Protheus SIGA"+cModulo+" "+aUsuarios[nI,3,nA,1] ;
						BODY        aUsuarios[nI,3,nA,2] ;
						ATTACHMENT  aUsuarios[nI,3,nA,3];   
						RESULT      lResult
					Next

					If !lResult
						//Erro no envio do email
						If lMsgError
							GET MAIL ERROR cError
							MsgInfo(cError,OemToAnsi("Erro no envio de e-Mail")) // "Erro no envio de e-Mail"
						Endif
					EndIf
				EndIf
				If ! lResult
					DISCONNECT SMTP SERVER
				Endif
			Endif
		Next
		DISCONNECT SMTP SERVER
	EndIf

Return Nil


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Escola Graduada                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DispBrow(cMarca,lInverte,cArq,oMark)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf

	DbSelectArea( cArq )
	If IsMark("OK",cMarca,lInverte)

	Else

	Endif
	oMark:oBrowse:Refresh(.t.)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EGF003    ºAutor  ³Microsiga           º Data ³  02/19/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BrowInverte(cMarca,cArq,oMark)
	Local nReg := (cArq)->(Recno())
	Local cAlias := Alias()
	dbSelectArea(cArq)
	dbGoTop()
	While !Eof()
		RecLock(cArq)
		(cArq)->OK := IIF((cArq)->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	(cArq)->(dbGoto(nReg))

	oMark:oBrowse:Refresh(.t.)
Return Nil




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³QA_USUARIO³ Autor ³ Aldo Marini Junior       ³ Data ³ 09/08/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Retorna um array com dados do Usuario Logado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³QA_USUARIO()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³Nenhum                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SIGAQNC - Generico                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/           
User Function QA_USUARIO()
	Local aArea := GetArea()

	Local aArray := {.F.,"","","","",""}	

	aArray[1]:= .T.
	aArray[2]:= SM0->M0_FILIAL 
	aArray[3]:= __cUserID 
	aArray[4]:= " "

	PswOrder(1)
	PswSeek(__CUSERID)
	aRetUser := PswRet(1)
	If !Empty(aRetUser[1][14])
		aArray[5] := AllTrim(aRetUser[1][14])
	Else
		aArray[5] := "SIGA"+cModulo
	EndIf

	aArray[6]:= UsrFullName(__cUserID)

	RestArea(aArea)

Return aArray

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ QNCXRMAIL  ³ Autor ³ Carlos R Moreira      ³ Data ³ 30/12/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela de digitação do email e corpo do email.    			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QNCXRMAIL()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAQNC				                 					    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function QNCXRTO()

	Local cEmail := cEmailFor    
	Local cCorpo := cMensPed  //"Teste de mensagem para o corpo de pedido de compra"  
	Local lLista := .T.  
	Local lCancel:= .T.
	Local oEmail
	Local oCorpo
	Local oDlg

	DEFINE MSDIALOG oDlg FROM 12,35 TO 33, 90 TITLE OemToAnsi("Informe os Emails para envio.") //
	@ 03,03	  TO 34,215 LABEL OemToAnsi("Para :") OF oDlg PIXEL  //"Para :"
	@ 34,03	  TO 138,215 LABEL OemToAnsi("Mensagem :") OF oDlg PIXEL  //"Mensagem :"
	@ 11,06   GET oEmail VAR cEmail MEMO SIZE 205,20 OF oDlg PIXEL 
	@ 42,06   GET oCorpo VAR cCorpo MEMO SIZE 205,93 OF oDlg PIXEL 
	@ 142,142 BUTTON OemToAnsi("&Enviar") OF oDlg SIZE 35, 12 ACTION IIF(!Empty(cEmail),(lCancel := .F.,oDlg:End()),.t.) PIXEL //"&Enviar"
	@ 142,180 BUTTON OemToAnsi("&Cancelar") OF oDlg SIZE 35, 12 ACTION (oDlg:End()) PIXEL //
	ACTIVATE DIALOG oDlg CENTERED
	If lCancel
		cEmail := ""
		cCorpo := ""
	Endif

Return({cEmail,cCorpo})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SelEmp    ºAutor  ³Carlos R. Moreira   º Data ³  06/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Seleciona as empresas                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SelEmp1(cRet)
	Local aEmp := {}
	Local aCampos := {}
	Local aUser := {}
	Local aEmpUser := {}

	PswOrder(1)
	If PswSeek(__cUserId)
		/*		If Select("SM0") > 0
		aEmpresas := {}
		nRecSM0 := SM0->(Recno())
		SM0->(dbGotop())
		While SM0->(!Eof())

		If SM0->M0_CODFIL # "01"
		DbSkip()
		Loop
		EndIf

		Aadd(aEmpresas,SM0->M0_CODIGO)
		SM0->(dbSkip())
		End
		SM0->(DbGoTo(nRecSM0))
		EndIf
		*/

	EndIf

	AaDd(aCampos,{"OK"        ,"C",2,0})
	AaDd(aCampos,{"EMP"       ,"C", 2,0})
	AaDd(aCampos,{"NOME"      ,"C",30,0})

	cArqTmp := CriaTrab(aCampos,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o arquivo de Trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbUseArea(.T.,,cArqTmp,"TRB1",.F.,.F.)
	IndRegua("TRB1",cArqTmp,"EMP",,,"Selecionando Registros..." )

	DbSelectArea("SM0")

	aAreaSM0 := GetArea()

	DbGotop()
	ProcRegua( RecCount())

	While SM0->(!Eof())

		IncProc("Processando a Empresa "+SM0->M0_CODIGO)

		If SM0->M0_CODFIL # "01"
			DbSkip()
			Loop
		EndIf

		//	nPesq := Ascan(aEmpUser,SM0->M0_CODIGO)
		//	If nPesq > 0 .Or. aEmpUser[01] == "@@"

		//		nPesq := Ascan(aEmpresas,SM0->M0_CODIGO)
		//		If nPesq > 0 .Or. aEmpresas[1] == "@@"

		DbSelectArea("TRB1")
		If !DbSeek(SM0->M0_CODIGO )
			RecLock("TRB1",.T.)
			TRB1->EMP       := SM0->M0_CODIGO
			TRB1->NOME      := SM0->M0_NOMECOM
			MsUnlock()
		EndIf
		//		EndIf
		DbSelectArea("SM0")
		SM0->(DbSkip())

	End

	TRB1->(DbGoTop())

	aBrowse := {}
	AaDD(aBrowse,{"OK","",""})
	AaDD(aBrowse,{"EMP","","Empresa"})
	AaDD(aBrowse,{"NOME","","Nome"})

	nOpca    :=0
	lInverte := .F.
	cMarca   := GetMark()

	DEFINE MSDIALOG oDlg1 TITLE "Seleciona Empresa" From 9,0 To 26,55 OF oMainWnd

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Passagem do parametro aCampos para emular tamb‚m a markbrowse para o ³
	//³ arquivo de trabalho "FUNC".                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oMark := MsSelect():New("TRB1","OK","",aBrowse,@lInverte,@cMarca,{15,3,123,205})

	oMark:bMark := {| | fa060disp(cMarca,lInverte)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca) }

	ACTIVATE MSDIALOG oDlg1 ON INIT LchoiceBar(oDlg1,{||nOpca:=0,oDlg1:End()},{||nOpca:=0,oDlg1:End()}) centered

	DbSelectArea("TRB1")
	DbGoTop()
	aEmp := {}
	lPri := .T.
	While TRB1->(!Eof())


		If ! Empty(TRB1->OK)
			If cRet == "C"
				If lPri
					cEmp := TRB1->EMP
					lPri := .F.
				Else
					cEmp += "#"+TRB1->EMP
				EndIf
			ElseIf cRet == "V"
				AaDD(aEmp,TRB1->EMP)
			EndIf

		EndIf

		DbSkip()

	End

	TRB1->(DbCloseArea())

	RestArea( aAreaSM0 )

Return If(cRet=="C",cEmp,aEmp)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA060Disp ³ Autor ³ Carlos R. Moreira     ³ Data ³ 09/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibe Valores na tela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Especifico Rhoss Print                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa060Disp(cMarca,lInverte)
	Local aTempos, cClearing, oCBXCLEAR, oDlgClear,lCOnf
	If IsMark("OK",cMarca,lInverte)
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Fa060Inve ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³inverte a Selecao dos Itens                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa060Inverte(cMarca)
	Local nReg := TRB1->(Recno())
	Local cAlias := Alias()
	dbSelectArea("TRB1")
	dbGoTop()
	While !Eof()
		RecLock("TRB1")
		TRB1->OK := IIF(TRB1->OK == "  ",cMarca,"  ")
		MsUnlock()
		dbSkip()
	Enddo
	TRB1->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)
Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LchoiceBar³ Autor ³ Pilar S Albaladejo    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mostra a EnchoiceBar na tela                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LchoiceBar(oDlg,bOk,bCancel)
	Local oBar, bSet15, bSet24, lOk
	Local lVolta :=.f.

	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlg
	//DEFINE BUTTON RESOURCE "S4WB011N" OF oBar GROUP ACTION ProcNome() TOOLTIP OemToAnsi("Procura por Nome..")
	DEFINE BUTTON oBtOk RESOURCE "OK" OF oBar GROUP ACTION ( lLoop:=lVolta,lOk:=Eval(bOk)) TOOLTIP "Ok - <Ctrl-O>"
	SetKEY(15,oBtOk:bAction)
Return

Static Function ButtonOff(bSet15,bSet24,lOk)
	DEFAULT lOk := .t.
	IF lOk
		SetKey(15,bSet15)
		SetKey(24,bSet24)
	Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ProcNome  ºAutor  ³Carlos R. Moreira   º Data ³  19/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Localiza o Nome do Professor                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Escola Graduada                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcNome()
	Local cNome := Space(20)
	Local oDlgProc

	DEFINE MSDIALOG oDlgProc TITLE "Procura Nome" From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite o Nome: " Size 50,10 of oDlgProc Pixel
	@ 13,45 Get cNome Picture "@!" Size 60,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action PosNom(@cNome,oDlgProc)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

Return

Static Function PosNom(cNome,oDlgProc)

	TRB1->(DbSeek(cNome,.T.))

	Close(oDlgProc)

Return

Static Function BuscaUser()

	aAllUsers:= AllUsers()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPed    ºAutor  ³Carlos R. Moreira   º Data ³  10/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira liberar o pedido de venda se estiver ok com a lib de    º±±
±±º          ³MArgem                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LibPed(cPedido,lFat)

	wAreaAnt	 := GetArea()
	wAreaSC5	 := SC5->(GetArea())
	wAreaSC6	 := SC6->(GetArea())
	wAreaSC9	 := SC9->(GetArea())
	wAreaSB1	 := SB1->(GetArea())
	wAreaSB2	 := SB2->(GetArea())
	wAreaSF4	 := SF4->(GetArea())
	wAreaSA1	 := SA1->(GetArea())

	Conout("Função de Liberação de Pedido")

	nTipo   := Space(1)
	nStatus := Space(2)


	DbSelectarea("SC6")
	DbSetorder(1)
	DbSeek(xFilial("SC6")+cPedido)

	While !Eof() .AND. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cPedido

		DbSelectArea("SF4")
		DbSeek(xFilial("SF4")+SC6->C6_TES)

		DbSelectArea("SB2")
		dBSetOrder(1)
		If dBSeek(xfilial("SB2")+SC6->C6_PRODUTO+SC6->C6_Local) .and.;
		SF4->F4_ESTOQUE=="S"
		Endif

		SA1->(DbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA ))

		dbSelectArea("SC6")

		RecLock("SC6",.F.)
		SC6->C6_QTDLIB := SC6->C6_QTDVEN
		MsUnlock()

		/* MALIBDOFAT
		±±³Parametros³ExpN1: Registro do SC6                                      ³±±
		±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
		±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
		±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
		±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
		±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
		±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
		±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
		±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
		±±³          ³       apenas avalia ).                                     ³±±
		±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
		±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
		±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
		±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
		±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
		±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
		*/
		MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.F.,.F.)

		If SA1->A1_ZZFORPA == "D" //Cliente que tem que passar pelo credito 
			Reclock("SC9",.F.)
			SC9->C9_BLCRED := "01"
			MsUnlock()

		ElseIf SC5->C5_ZZTIPO == "F"
			Reclock("SC9",.F.)
			SC9->C9_BLCRED := " "
			MsUnlock()

		EndIf 

		ConOut("MALIBDOFAT Executada")

		dbSelectArea("SC6")
		DBSkip()

	End

	//Verifico se houve duplicidade
	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If SC9->C9_SEQUEN == "02"
			Reclock("SC9",.F.)
			SC9->(DbDelete())
			MsUnlock()
		EndIf

		SC9->(DbSkip())

	End

	lBlqCred := .F.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If !Empty(SC9->C9_BLCRED) .And. SC9->C9_BLCRED # "10"
			lBlqCred := .T.
			Exit
		EndIf

		SC9->(DbSkip())

	End

	If ! SC5->C5_ZZTIPO $ "N,F"

		Return 

	EndIf 
	//Quando Houver bloqueio de Credito Flega o SC5 e Estorna os empenhos
	If lBlqCred

		DbSelectArea("SC9")
		DbSetOrder(1)
		DbSeek(xFilial("SC9")+cPedido )

		While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

			If !Empty(SC9->C9_BLEST) .Or. SC9->C9_BLEST == "10"
				SC9->(DbSkip())
				Loop
			EndIf

			//Estorno a qtd que gera reserva..
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
				RecLock("SB2",.F.)
				SB2->B2_RESERVA -= SC9->C9_QTDLIB
				MsUnlock()
			Endif

			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
				RecLock("SC6",.F.)
				SC6->C6_QTDLIB := 0
				SC6->C6_QTDEMP := 0
				SC6->C6_QTDEMP2 := 0
				MsUnlock()
			EndIf

			DbSelectArea("SC9")
			RecLock("SC9",.F.)
			SC9->C9_BLEST := "02" 
			MsUnlock()
			SC9->(DbSkip())

		End

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "C"
		MsUnlock()

		// Retorna as areas originais colocado por Keller
		RestArea(wAreaSF4)
		RestArea(wAreaSB2)
		RestArea(wAreaSB1)
		RestArea(wAreaSC9)
		RestArea(wAreaSC6)
		RestArea(wAreaSC5)
		RestArea(wAreaAnt)

		Return 

	EndIf

	//Vou deixar com bloqueio de estoque 
	lBlqEst := .F.

	DbSelectArea("SC9")
	DbSetOrder(1)
	DbSeek(xFilial("SC9")+cPedido )

	While SC9->(!Eof()) .And. SC9->C9_PEDIDO == cPedido

		If !Empty(SC9->C9_BLEST) .And. SC9->C9_BLEST # "10"
			lBlqEst := .T.
			SC9->(DbSkip())
			Loop
		EndIf

		//Estorno a qtd que gera reserva..
		DbSelectArea("SB2")
		If DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL )
			RecLock("SB2",.F.)
			SB2->B2_RESERVA -= SC9->C9_QTDLIB
			MsUnlock()
		Endif

		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM )
			RecLock("SC6",.F.)
			SC6->C6_QTDLIB := 0
			SC6->C6_QTDEMP := 0
			SC6->C6_QTDEMP2 := 0
			MsUnlock()
		EndIf

		DbSelectArea("SC9")
		RecLock("SC9",.F.)
		SC9->C9_BLEST := "02" 
		MsUnlock()

		SC9->(DbSkip())

	End

	If Empty(SC5->C5_STAPED) .Or. lBlqEst 

		DbSelectArea("SC5")
		RecLock("SC5",.F.)
		SC5->C5_STAPED := "L"
		MsUnlock()

	EndIf

	// Retorna as areas originais colocado por Keller
	RestArea(wAreaSF4)
	RestArea(wAreaSB2)
	RestArea(wAreaSB1)
	RestArea(wAreaSC9)
	RestArea(wAreaSC6)
	RestArea(wAreaSC5)
	RestArea(wAreaAnt)

	MsUnlockAll()

Return
