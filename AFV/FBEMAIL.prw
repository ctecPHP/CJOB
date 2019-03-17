#INCLUDE "totvs.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} FBEMail
   Utilizando classe TMailMessage
@author  Fernando Bueno - FBSolutions
@since   date
@version version
/*/
//-------------------------------------------------------------------
User Function FBEMail(cPara, cAssunto, cMensagem, aArquivos)
	Local cMsg := ""
	Local xRet
	Local oServer, oMessage
	Local lMailAuth	:= SuperGetMv("MV_RELAUTH",,.F.)
	Local nPorta := 587 //informa a porta que o servidor SMTP irá se comunicar, podendo ser 25 ou 587
			
	Private cMailConta	:= NIL
	Private cMailServer	:= "smtp.sobelsuprema.com.br" //Provisório, pois no parametro já existe a porta
	Private cMailSenha	:= NIL
	
	Default aArquivos := {}

	cMailConta :=If(cMailConta == NIL,GETMV("MV_RELACNT"),cMailConta)             //Conta utilizada para envio do email
	cMailServer:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Servidor SMTP
	cMailSenha :=If(cMailSenha == NIL,GETMV("MV_RELPSW"),cMailSenha)             //Senha da conta de e-mail utilizada para envio
   	oMessage:= TMailMessage():New()
	oMessage:Clear()
   
	oMessage:cDate	 := cValToChar( Date() )
	oMessage:cFrom 	 := cMailConta
	oMessage:cTo 	 := cPara
	oMessage:cSubject:= cAssunto
	oMessage:cBody 	 := cMensagem
	
	If Len(aArquivos) > 0
		For nArq := 1 To Len(aArquivos)
			xRet := oMessage:AttachFile( aArquivos[nArq] )
			if xRet < 0
				cMsg := "O arquivo " + aArquivos[nArq] + " não foi anexado!"
				alert( cMsg )
				return
			endif
		Next nArq
	EndIf		
	   
	oServer := tMailManager():New()
	oServer:SetUseTLS( .F. ) //Indica se será utilizará a comunicação segura através de SSL/TLS (.T.) ou não (.F.)
   
	xRet := oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPorta ) //inicilizar o servidor
	if xRet != 0
		alert("O servidor SMTP não foi inicializado: " + oServer:GetErrorString( xRet ) )
		return
	endif
   
	xRet := oServer:SetSMTPTimeout( 60 ) //Indica o tempo de espera em segundos.
	if xRet != 0
		alert("Não foi possível definir " + cProtocol + " tempo limite para " + cValToChar( nTimeout ))
	endif
   
	xRet := oServer:SMTPConnect()
	if xRet <> 0
		alert("Não foi possível conectar ao servidor SMTP: " + oServer:GetErrorString( xRet ))
		return
	endif
   
	if lMailAuth
		//O método SMTPAuth ao tentar realizar a autenticação do 
		//usuário no servidor de e-mail, verifica a configuração 
		//da chave AuthSmtp, na seção [Mail], no arquivo de 
		//configuração (INI) do TOTVS Application Server, para determinar o valor.
		xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
		if xRet <> 0
			cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
			alert( cMsg )
			oServer:SMTPDisconnect()
			return
		endif
   	Endif
	xRet := oMessage:Send( oServer )
	if xRet <> 0
		alert("Não foi possível enviar mensagem: " + oServer:GetErrorString( xRet ))
	endif
   
	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		alert("Não foi possível desconectar o servidor SMTP: " + oServer:GetErrorString( xRet ))
	endif
return