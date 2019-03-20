#INCLUDE "RWMAKE.CH"
#include "ap5mail.ch" 
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FKXFUN    �Autor  �Carlos R. Moreira   � Data �  05/14/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcoes comuns no Cliente                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Fortknox                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Carlos R. Moreira   � Data �  03/19/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida o grupo de Perguntas                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CABREL    �Autor  �Carlos R.Moreira    � Data �  05/12/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Emite o cabecalho padrao para os relatorios customizados    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Escola Graduada                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	oPrn:Say( 80,  1820, "Emiss�o : "+Dtoc(dDataBase),oFont3,100 )
	
	oPrn:Say( 150, 1820, "P�gina  : "+StrZero(nPag,3),oFont3,100 )
	
	oPrn:Say( 220, 1820, "Hora  : "+Time(),oFont3,100 )

	oPrn:Say( 270, 2020, cProg ,oArial06Neg ,100 )	
EndIf

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FKXFUN    �Autor  �Microsiga           � Data �  10/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AceVarQry()

Local cFilterUser := ""
If !Empty(aReturn[7])
	//�����������������������������������������������Ŀ
	//� Cria Filtro das Notas de Devolucao            �
	//�������������������������������������������������
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
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun�ao    �Fc021ProcEx� Autor � Claudio D. de Souza  � Data � 25-04-2005 ���
���������������������������������������������������������������������������Ĵ��
���Descri�ao �Processa a exportacao da planilha de trabalho para o Excel.   ���
���������������������������������������������������������������������������Ĵ��
��� Uso      �FINC021                                                       ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function Run_Excel(aDadosExcel,nCol)
LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX,nY
	
ProcRegua(Len(aDaDosExcel))

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0
	

	For nX := 1 to Len(aDadosExcel)
  
		IncProc("Aguarde! Gerando arquivo de integra��o com Excel...") // 
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
	MsgAlert( "Falha na cria��o do arquivo" ) // 
Endif	

Return

/*
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Fun��o    � 	Env_Email   � Autor � Carlos R. Moreira� Data � 28/03/02 ���
������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que envia email                            		 ���
������������������������������������������������������������������������Ĵ��
���Parametros� cEmailTo:	Email do Destinatario.                       ���
���		     � cEmailCC:	Outras Contas para mandar Copia do email.    ���
���		     � cAssunto:	Assunto do Email.							 ���
���		     � cMensagem:	Mensagem do Corpo do email.                  ���
���		     � cAttach:		Arquivos a serem attachados no email.    	 ���
���			 � cChave:		Filial + Matricula do funcionario.  		 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Generica                                                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

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
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � QNCXRMAIL  � Autor � Cicero Cruz           � Data � 26/09/04 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Rotina de envio do email generica de Relat�rio. 			    ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � QNCXRMAIL()                                                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAQNC				                 					    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function  QNCXRMAIL(aRel) 

Local aArqAux := {}   
Local aAttach := {}  
Local aDados  := QNCXRTO() 
Local cBody   := "" 
Local cAttach := "" 
Local cSubject := IIF(aRel[1,3]=="","",aRel[1,3])
Local aUsrMat := U_QA_USUARIO() 
Local nX      := 0 
Local nY      := 0 
// �������������������������������������Ŀ
// | Valida digita��o dos destinatarios. |
// ���������������������������������������
If Empty(aDados[1])                                     
	Return
EndIF	
// ����������������������������������������������������Ŀ
// |Gerando Corpo do Email com os Relatorios gerados.   |
// ������������������������������������������������������
If !Empty(aDados[2])
	cBody := Alltrim(aDados[2])
	cBody += CHR(13)+CHR(10)+CHR(13)+CHR(10)
EndIF
// ����������������������������������Ŀ
// |Anexa  arquivos                   |
// |       aRel{Path,Arquivo}         |
// ������������������������������������
For nX:=1 to Len(aRel)      
	// �������������������������������������Ŀ
	// | Verifico o arquivo.                 |
	// ���������������������������������������
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
// �������������������������������������Ŀ
// | Monta dados para envio do email.    |
// ���������������������������������������
AADD(aArqAux,{" - " + cSubject,cBody,cAttach}) 
aUsuarios := {{"",aDados[1],aArqAux,"2"} }
U_QaEnvMail(aUsuarios,,,,aUsrMat[5],"2" )  // "2"   

// ������������������������������������������������Ŀ
// | Deleta arquivos JPEG gerados pelos relatorios. |
// ��������������������������������������������������
For nY:=1 to Len(aAttach)
	FErase( cStartPath+aAttach[nY,1] )
Next nY 

Return               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �QAEnvMail � Autor � Aldo Marini Junior    � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que envia e-mail de acordo com array                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QAEnvMail(ExpA1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os dados de envio (To,Subject,Body,      ���
���          �         Attachment)                                        ���
���          � ExpC1 = Caracter contendo conta de acesso ao servidor      ���
���          � ExpC2 = Caracter contendo o endereco do servidor           ���
���          � ExpC3 = Caracter contendo senha de acesso ao servidor      ���
���          � ExpC4 = Caracter contendo a conta do Usuario logado        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � lResult = Logico retornando se houve algum erro no envio   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//���������������������������������������������������������������������������������Ŀ
//� Verifica se a conta de email do usuario esta com mais de uma e considera apenas �
//� a primeira para conectar e enviar email                                         �
//�����������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �QARunMail � Autor � Aldo Marini Junior    � Data � 26/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que envia e-mail Mostrando Msg de Processamento     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QARunMail(ExpA1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1 = Array com os dados de envio (To,Subject,Body,      ���
���          �         Attachment)                                        ���
���          � ExpC1 = Caracter contendo conta de acesso ao servidor      ���
���          � ExpC2 = Caracter contendo o endereco do servidor           ���
���          � ExpC3 = Caracter contendo senha de acesso ao servidor      ���
���          � ExpL1 = Logical  indicando Erro na Conexao ao Servidor     ���
���          � ExpC4 = Caracter contendo a conta do Usuario logado        ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � lResult = Logico retornando se houve algum erro no envio   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GENERICO                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PerContra �Autor  �Carlos R Moreira    � Data �  09/27/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ira procurar nos contratos se o cliente deva gerar NCC      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Scarlat                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PerContratos(cCliente,cLoja,lMarcaPro)
Local aArea := GetArea()
Local nPerc := 0
                                                               
If lMarcaPro 
BeginSql Alias "QRYCON"
	
	SELECT   ZZ6_CLIENT, ZZ6_LOJA, ZZ6_CODIGO, ZZ6_STATUS, ZZ6_TIPO, ZZ6_GRUPO, ZZ6_DGRUPO, ZZ6_REVISA
	FROM     %Table:ZZ6%
	WHERE    (D_E_L_E_T_ <> '*') AND (ZZ6_STATUS = '2') AND ( ZZ6_MARPRO = '1' )
	
EndSql       
Else
BeginSql Alias "QRYCON"
	
	SELECT   ZZ6_CLIENT, ZZ6_LOJA, ZZ6_CODIGO, ZZ6_STATUS, ZZ6_TIPO, ZZ6_GRUPO, ZZ6_DGRUPO, ZZ6_REVISA
	FROM     %Table:ZZ6%
	WHERE    (D_E_L_E_T_ <> '*') AND (ZZ6_STATUS = '2')  AND ( ZZ6_MARPRO <> '1' )
	
EndSql       

EndIf 

DbSelectArea("QRYCON")
DbGotop()

If QRYCON->(Eof())
	QRYCON->(DbCloseArea())
	RestArea(aArea)
	Return nPerc
EndIf

While QRYCON->(!Eof())                

	SA1->(DbSetorder(1))
	SA1->(DbSeek(xFilial("SA1")+cCliente+cLoja ))
	
	If QRYCON->ZZ6_TIPO == "3"
		
		If QRYCON->ZZ6_CLIENT+QRYCON->ZZ6_LOJA # cCliente+cLoja
			QRYCON->(DbSkip())
			Loop
		EndIf
		
	ElseIf QRYCON->ZZ6_TIPO == "2"
		
		If QRYCON->ZZ6_GRUPO # SA1->A1_REDESCA
			QRYCON->(DbSkip())
			Loop
		EndIf
		
	ElseIf QRYCON->ZZ6_TIPO == "1"
		
		If QRYCON->ZZ6_CLIENT # cCliente
			QRYCON->(DbSkip())
			Loop
		EndIf
		
	EndIf
	
	DbSelectArea("ZZ7")
	DbSetorder(1)
	DbSeek(xFilial("ZZ7")+QRYCON->ZZ6_CODIGO )
	
	While ZZ7->(!Eof()) .And. QRYCON->ZZ6_CODIGO == ZZ7->ZZ7_CODIGO
		
        If ZZ7->ZZ7_REVISA #  QRYCON->ZZ6_REVISA
           DbSkip()
           Loop
        EndIf 
		
		If Alltrim(ZZ7->ZZ7_PERIOD) # "1"
			DbSkip()
			Loop
		EndIf
		
//		If ! ZZ7_FORMA $  "3/4"
//			DbSkip()
//			Loop
//		EndIf
		
		nPerc += ZZ7->ZZ7_PERCER
		
		DbSelectArea("ZZ7")
		DbSkip()
		
	End
	
	DbSelectArea("QRYCON")
	QRYCON->(DbSkip())
	
End

QRYCON->(DbCloseArea())

RestArea(aArea)
Return nPerc


/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �FA060Disp � Autor � Carlos R. Moreira     � Data � 09/05/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exibe Valores na tela									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Especifico Escola Graduada                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EGF003    �Autor  �Microsiga           � Data �  02/19/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LibPed    �Autor  �Carlos R. Moreira   � Data �  10/29/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ira liberar o pedido de venda se estiver ok com a lib de    ���
���          �MArgem                                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Gtex                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LibPed(cPedido)

wAreaAnt	 := GetArea()
wAreaSC5	 := SC5->(GetArea())
wAreaSC6	 := SC6->(GetArea())
wAreaSC9	 := SC9->(GetArea())
wAreaSB1	 := SB1->(GetArea())
wAreaSB2	 := SB2->(GetArea())
wAreaSF4	 := SF4->(GetArea())
wAreaSA1	 := SA1->(GetArea())

Conout("Fun��o de Libera��o de Pedido")

nTipo := Space(1)
nStatus:= Space(2)

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
	SC6->C6_QTDLIB := If(SC5->C5_PERCRES>0,SC6->C6_QTDVEN * ( 1 - (SC5->C5_PERCRES / 100 )),SC6->C6_QTDVEN)
	MsUnlock()
	
	/* MALIBDOFAT
	���Parametros�ExpN1: Registro do SC6                                      ���
	���          �ExpN2: Quantidade a Liberar                                 ���
	���          �ExpL3: Bloqueio de Credito                                  ���
	���          �ExpL4: Bloqueio de Estoque                                  ���
	���          �ExpL5: Avaliacao de Credito                                 ���
	���          �ExpL6: Avaliacao de Estoque                                 ���
	���          �ExpL7: Permite Liberacao Parcial                            ���
	���          �ExpL8: Tranfere Locais automaticamente                      ���
	���          �ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ���
	���          �       apenas avalia ).                                     ���
	���          �ExpbA: CodBlock a ser avaliado na gravacao do SC9           ���
	���          �ExpAB: Array com Empenhos previamente escolhidos            ���
	���          �       (impede selecao dos empenhos pelas rotinas)          ���
	���          �ExpLC: Indica se apenas esta trocando lotes do SC9          ���
	���          �ExpND: Valor a ser adicionado ao limite de credito          ���
	���          �ExpNE: Quantidade a Liberar - segunda UM                    ���
	*/
	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.F.,.F.)
	
	If SC5->C5_OPER $ "01#09"
		If SC5->C5_CONDPAG == "001" .And. SC5->C5_TIPO == "N" // Condicao a Vista deve ser Bloqueada no Credito
			DbSelectArea("SC9")
			RecLock("SC9",.F.)
			SC9->C9_BLCRED := "01"
			MsUnLock()
		EndIf
	Else
		
		DbSelectArea("SC9")
		RecLock("SC9",.F.)
		SC9->C9_BLCRED := "  "
		SC9->C9_BLEST  := "  "
		MsUnLock()
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
		
		
		SC9->(DbSkip())
		
	End
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_STATUS := "C"
	MsUnlock()
	
EndIf

If Empty(SC5->C5_STATUS)
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_STATUS := "L"
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


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun�ao    �QA_USUARIO� Autor � Aldo Marini Junior       � Data � 09/08/01 ���
����������������������������������������������������������������������������Ĵ��
���Descri�ao �Retorna um array com dados do Usuario Logado                   ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   �QA_USUARIO()                                                   ���
����������������������������������������������������������������������������Ĵ��
���Parametro �Nenhum                                                         ���
����������������������������������������������������������������������������Ĵ��
���Uso       �SIGAQNC - Generico                                             ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/           
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
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao    � QNCXRMAIL  � Autor � Carlos R Moreira      � Data � 30/12/14 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � Tela de digita��o do email e corpo do email.    			    ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � QNCXRMAIL()                                                  ���
���������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAQNC				                 					    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FSTAPED   �Autor  �Cristiano           � Data �  10/03/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Seleciona status do pedido qto LF-Liberado Faturamento;     ���
���          �BF-Bloqueio Financeiro;BC-Bloqueio Comercial;FT-Faturado    ���
���          �FP-Faturado Parcial                                         ���
�������������������������������������������������������������������������͹��
���Uso       � FSTAPED                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FSTAPED(l1Elem,lTipoRet)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""

Private aCat:={}

DEFAULT lTipoRet := .T.

l1Elem := If (l1Elem = Nil , .F. , .T.)

cAlias := Alias() 					 // Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

aCat :={;
"FP - Faturado Parcial",;
"FT - Faturado",;
"BC - Bloqueio Comercial",;
"BF - Bloqueio Financeiro",;
"BE - Bloqueio Estoque",;
"LF - Liberado Faturamento",;
"RL - Residuos Eliminados",;
"BL - Bloqueio Customer",;
"PE - Programada Entrega",;
"BM - Bloqueio Margem" }

MvParDef:="1234567890"
cTitulo :="Status Pedido"

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aCat,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
		mvpar := STRTRAN (mvpar,"1","'P'," )
		mvpar := STRTRAN (mvpar,"2","'F'," )
		mvpar := STRTRAN (mvpar,"3","'S'," )
		mvpar := STRTRAN (mvpar,"4","'C'," )
		mvpar := STRTRAN (mvpar,"5","'E'," )
		mvpar := STRTRAN (mvpar,"6","'D'," )
		mvpar := STRTRAN (mvpar,"7","'R'," )
		mvpar := STRTRAN (mvpar,"8","'L'," )
		mvpar := STRTRAN (mvpar,"9","'A'," )
		mvpar := STRTRAN (mvpar,"0","'M'" )		
		&MvRet := mvpar										 // Devolve Resultado
	EndIF
EndIF

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )
