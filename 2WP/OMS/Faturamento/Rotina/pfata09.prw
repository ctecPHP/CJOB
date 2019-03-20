#Include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "VKEY.CH"
#INCLUDE "colors.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ´PFATA09 ³ Autor ³ Carlos R. Moreira     ³ Data ³ 22.02.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa os Pedidos liberados e refaz as reservas          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFATA09()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Vari veis 										     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL nOpca := 0
	LOCAL oDlg
	Local aSays:={}, aButtons:={}

	PRIVATE cCadastro := OemToAnsi("Processa os Pedidos liberados")
	Private aPedidos := {}
	Private aEmp := {}
	Private nPesoPed := 0
	Private cTpFrete := " "
	Private nTotFreNeg := 0
	Private aOrdCarg  := {}
	Private lFiltraGru := .F.

	cEmpOri := cEmpAnt
	cFilOri := cFilAnt

	Private oFonte  := TFont():New( "TIMES NEW ROMAN",18.5,25,,.T.,,,,,.F.)
	Private oFont2  := TFont():New( "TIMES NEW ROMAN",12.5,12,,.T.,,,,,.F.)

	If !ExisteSX6("MV_C_EMP_R")
		CriarSX6("MV_C_EMP_R","C","Empresa que ira consolidar .",If(SM0->M0_CODIGO="01","02",""))
	EndIf

	cEmpCons := Alltrim(GetMV("MV_C_EMP_R"))

/*
	If SM0->M0_CODIGO # "01"
		MsgStop("Esta rotina deve ser executada na empresa 01")
		Return 
	EndIf   
*/
	AADD(aSays,OemToAnsi( " Este programa tem como objetivo selecionar os pedidos de vendas " ) ) //
	AADD(aSays,OemToAnsi( " liberados e refazer as reservas.                              " ) )

	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	//	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )

	FormBatch( cCadastro, aSays, aButtons )

	If nOpcA == 1

		Processa( {||PFATA09PROC()},"Processando o arquivo..")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLOGA03   ºAutor  ³Carlos R. Moreira   º Data ³  23/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ira selecionar os pedidos de Vendas                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PFATA09PROC()

	Local aColumns		:= {}
	Local aFields := {}
	Local oTempTable
	Local nI
	Local cQuery
	Local oDlg			:= Nil
	Local aSize		:= {}

	Local aArq := {{"SC9"," "}}

	aEmp := {}

	AaDD(aEmp,SM0->M0_CODIGO)

	If !Empty(cEmpCons)
		For nX := 1 to Len(cEmpCons) Step 2 
			AaDD(aEmp,Substr(cEmpCons,nX,2))
		Next 
	EndIf

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd(aFields,{"OK"     ,"C", 2,0})
	aadd(aFields,{"PROD"   ,"C",15,0})
	aadd(aFields,{"LOCAL"  ,"C", 2,0})	
	aadd(aFields,{"QTDLIB" ,"N",17,2})
	//oTemptable:SetFields( aFields )

	cTemp := CriaTrab(aFields,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria o arquivo de Trabalho³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbUseArea(.T.,,cTemp,"TRB",.F.,.F.)
	IndRegua("TRB",cTemp,"PROD+LOCAL",,,"Selecionando Registros..." )


	For nEmp := 1 to Len(aEmp)

		cArq   := "sx2"+aEmp[nEmp]+"0"
		cAliasROM := "sx2ROM"

		cPath := GetSrvProfString("Startpath","")
		cArq := cPath+cArq

		//Faco a abertura do SX2 da empresa que ira gerar o arquivo de trabalho
		Use  &(cArq ) alias &(cAliasROM) New

		If Select( cAliasROM ) == 0
			MsgAlert("Arquivo nao foi aberto..."+cArq)
			Return
		Else
			DbSetIndex( cArq )
		EndIf

		For nArq := 1 to Len(aArq)

			DbSelectArea( cAliasROM )
			DbSeek( aArq[nArq,1] )

			aArq[nArq,2] := (cAliasROM)->x2_arquivo

		Next

		If nEmp >  1
			cQuery += " Union All "
		Else
			cQuery := " "
		EndIf

		cQuery +=" SELECT  C9_PRODUTO, C9_LOCAL, SUM(C9_QTDLIB) AS C9_QTDLIB "
		cQuery +=" FROM " +aArq[Ascan(aArq,{|x|x[1] = "SC9" }),2]  
		cQuery +="  WHERE D_E_L_E_T_ <> '*' AND C9_BLEST = ' ' AND C9_PRODUTO <> ' ' " 
		cQuery +="   GROUP BY C9_PRODUTO,C9_LOCAL "   

		(cAliasROM)->(DbCloseArea())

	Next

	TCSQLExec(cQuery)

	MsAguarde({|| DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)},"Aguarde gerando o arquivo..")

	nTotReg := 0
	QRY->(dbEval({||nTotREG++}))
	QRY->(dbGoTop())

	DbSelectArea("QRY")

	ProcRegua(nTotReg)

	While QRY->(!Eof())

		IncProc("Gerando as selecao de Pedido de vendas...")

		DbSelectArea("TRB")
		If ! DbSeek(QRY->C9_PRODUTO+QRY->C9_LOCAL )
			RecLock("TRB",.T.)
			TRB->PROD   := QRY->C9_PRODUTO
			TRB->LOCAL  := QRY->C9_LOCAL
			TRB->QTDLIB := QRY->C9_QTDLIB
			MsUnlock()
		Else
			RecLock("TRB",.F.)
			TRB->QTDLIB += QRY->C9_QTDLIB          
			MsUnlock()
		EndIf 

		DbSelectArea("QRY")
		DbSkip()

	End 

    Processa({||PfATA09RUN(),"Atualizando o arquivo de saldos.."})
    
    QRY->(DbCloseArea())
    TRB->(DbCloseArea())
    
Return 


/*/

Executa a atualizacao do arquivo 

/*/ 


Static Function PFATA09RUN()

//zera as reservas para recontagem 
DbSelectArea("SB2")
DbGoTop()

While SB2->(!Eof())

   RecLock("SB2",.F.)
   SB2->B2_RESERVA := 0
   MsUnlock()
   
   DbSkip()
   
End 

Return 

//Atualizo as reservas com os valores corretos
DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())

While TRB->(!Eof())

     IncProc("Processando o aquivo temporario..")
     
     DbSelectArea("SB2")
     DbSetOrder(1)
     If DbSeek(xFilial('SB2')+TRB->PROD+TRB->LOCAL )
        RecLock("SB2",.F.)
        SB2->B2_RESERVA := TRB->QTDLIB 
        MsUnlock()   
     EndIf
     
     DbSelectArea("TRB")
     DbSkip()

End

Return 