#include 'totvs.ch'
#include 'ap5mail.ch'
//-------------------------------------------------------------------
/*/{Protheus.doc} envemail
description
@author  author
@since   date
@version version
/*/
//-------------------------------------------------------------------
user function envemail(cDe,cPara,cCC,cCO,cAssunto,cMsg)
    Local lResulConn := .T.
    Local lResulSend := .T.
    Local lResult    := .T.
    Local cError     := ""   
    Local cRet       := ""                                         
    Local _cUsuario  := 'assistente_ti@sobelsuprema.com.br' //GetMV("MV_MAILUSE")
    Local _cSenha    := 'Ade*ade@4522'//Embaralha(GetMV("MV_MAILPAS"), 1) 
    Local _lJob      
    
    lResulConn := MailSmtpOn( "smtp.sobelsuprema.com.br", _cUsuario, _cSenha)
    If !lResulConn//GET MAIL ERROR 
        cErrorcError := MailGetErr()
        If _lJob
            cRet := Padc("Falha na conexao "+cErrorcError)
        Else
            cRet := "Falha na conexao "+cError
        Endif
        Return(.F.)
    Endif
 
    SEND MAIL FROM cDe TO cPara CC cCC BCC cCO SUBJECT cAssunto BODY cMsg FORMAT TEXT RESULT lResulSend
    
    if !lResulSend
        cRet:= "Falha no Envio!"
    else
        cRet:= "E-mail enviado com sucesso!"
    endif
 
return(cRet)