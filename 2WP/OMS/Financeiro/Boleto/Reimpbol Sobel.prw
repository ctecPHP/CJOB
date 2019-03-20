#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ BOLETIMP ³ Autor ³ Carlos R Moreira      ³ Data ³ 25/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para impressao de boletos bancarios pela segunda  ³±±
±±³ 		 ³ vez, de acordo com a primeira impressão                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ [1] lDanfe - Define se a impressão é a partir da DANFE 	  ³±±
±±³ 		 ³ [2] aParam - Parametros do titulo que sera impresso        ³±±
±±³ 		 ³ 		aParam[1] - Prefixo do titulo						  ³±±
±±³ 		 ³ 		aParam[2] - Do Titulo Financeiro				      ³±±
±±³ 		 ³ 		aParam[3] - Ate o titulo financeiro					  ³±±
±±³ 		 ³ 		aParam[4] - Da Parcela Inicial						  ³±±
±±³ 		 ³ 		aParam[5] - Ate a Parcela Final    					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Depend.   ³ BOLETBCO - Define os dados do banco e autoriza impressao   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ReImpBol(lDanfe,aParam)

	Local lReimp    := .F.

	PRIVATE nCB1Linha	:= 14.5
	PRIVATE nCB2Linha	:= 26.1
	Private nCBColuna	:= 1.3
	Private nCBLargura	:= 0.0280
	Private nCBAltura	:= 1.4

	aRegs := {}
	cPerg		:= "BOLETOBCO"

	aAdd(aRegs,{cPerg,"01","Prefixo            ?","","","mv_ch1","C"   ,03    ,00      ,0   ,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Titulo Inicial     ?","","","mv_ch2","C"   ,09    ,00      ,0   ,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Titulo Final       ?","","","mv_ch3","C"   ,09    ,00      ,0   ,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"04","Emissao Ate        ?","","","mv_ch4","D"   ,08    ,00      ,0   ,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"05","Romaneio de        ?","","","mv_ch5","C"   ,06    ,00      ,0   ,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	//	aAdd(aRegs,{cPerg,"06","Romaneio Ate       ?","","","mv_ch6","C"   ,06    ,00      ,0   ,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"07","Filtrar notas      ?","","","mv_ch7","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR07","Em Aberto"  ,"","","","","Entregue","","","","","Todas","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"08","Filtra Zona        ?","","","mv_ch8","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR08","Sim"  ,"","","","","Nao","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"09","Tipo de Carga      ?","","","mv_ch9","N"  , 01   ,0       ,1   ,"C","" ,"MV_PAR09","Batida"  ,"","","","","Paletizada","","","","","","","","","","","","","","","","","","","",""})

	//	aAdd(aRegs,{cPerg,"10","Data de carregamento   ?","","","mv_chA","D"   ,08    ,00      ,0   ,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	U_ValidPerg(cPerg,aRegs)

	If !lDanfe

		If !Pergunte(cPerg,.T.)
			Return
		EndIf
	Else
		Pergunte(cPerg,.F.)
		MV_PAR01:= aParam[1]
		MV_PAR02:= aParam[2]
		MV_PAR03:= aParam[3]
		MV_PAR04:= aParam[4]
		MV_PAR05:= aParam[5]

	EndIf

	Processa( {||ReEmiBol(lDanfe)},"Imprimindo os Boletos...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REIMPBOL  ºAutor  ³Microsiga           º Data ³  08/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReEmiBol(lDanfe)
	LOCAL   oPrint
	LOCAL   n := 0
	LOCAL aBitmap := "BANCO.BMP"

	LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                            ,; //[1]Nome da Empresa
	SM0->M0_ENDCOB                                                              ,; //[2]Endereço
	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
	"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
	"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
	Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

	LOCAL aDadosTit
	LOCAL aDadosBanco  := {}
	LOCAL aDatSacado
	LOCAL aBolText     := {} 

	/*
	oPrint:Say  (1100,100 ," APÓS O VENCIMENTO MULTA DE R$ "+Alltrim(Transform((aDadosTit[5]*2)/100,"@E 999,999,999.99"))  ,oFont10)  // 2%
	oPrint:Say  (1150,100 ," APÓS O VENCIMENTO, COBRAR MORA DE R$ "+Alltrim(transform((aDadosTit[5]*0.33)/100,"@E 999.99"))+" AO DIA"  ,oFont10)
	oPrint:Say  (1200,100 ," PROTESTAR APÓS 05 DIAS CORRIDOS DO VENCIMENTO"  ,oFont10)

	If SA1->A1_ZZCONTR > 0
	oPrint:Say  (1250,100 ," ATÉ "+DTOC(aDadosTit[4])+" DESCONTO DE "+Alltrim(transform(aDadosTit[5]*(SA1->A1_ZZCONTR)/100,"@E 999,999.99"))  ,oFont10)
	Endif                                                                     

	oPrint:Say  (1350,100 ," TELEFONE DE COBRANÇA (11) 3382-2944 RAMAL 2926/2908"  ,oFont10)
	*/

	//LOCAL aBolText     := {"",;
	//"Mora Diaria de R$ "                                   ,;
	//"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

	// "Após o vencimento cobrar multa de R$ "

	LOCAL i            := 1
	LOCAL CB_RN_NN     := {}
	LOCAL nRec         := 0
	LOCAL _nVlrAbat    := 0
	LOCAL cParcela	   := ""
	LOCAL lSubs		   := .F.
	LOCAL aArea		   := GetArea()

	Private cStartPath 	:= GetSrvProfString("Startpath","\BOLETO\")
	cMensPed := "Teste de mensagem do pedido de compra "

	lEmail := .F.
	If !lDanfe
		If MsgYesNo("Deseja Enviar por e-mail" )
			lEmail := .T.
		EndIf
	EndIf

	If lEmail
		cJPEG := "BL"+MV_PAR02 //CriaTrab(,.F.)
	EndIf

	lPriEmiBol := .F.

	If lDanfe
		DbSelectArea("SE1")
		DbSetOrder(1)

		DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02,.T. ) //

		While SE1->(!EOF()) .And. SE1->E1_PREFIXO+SE1->E1_NUM <= MV_PAR01+MV_PAR03

			If lDanfe

				If SE1->E1_ZZEMIBO == "S"
					DbSkip()
					Loop
				EndIf

			EndIf

			lPriEmiBol := .T.

			DbSkip()

		End

		If !lPriEmiBol
			Return
		EndIf

	EndIf

	oPrint:= TMSPrinter():New( "Boleto Laser" )
	oPrint:SetPortrait() // ou SetLandscape()
	oPrint:StartPage()   // Inicia uma nova página
	oPrint:SetPaperSize(9)

	oPrint:Setup()

	DbSelectArea("SE1")
	DbSetOrder(1)

	DbSeek(xFilial("SE1")+MV_PAR01+MV_PAR02,.T. ) //

	While SE1->(!EOF()) .And. SE1->E1_PREFIXO+SE1->E1_NUM <= MV_PAR01+MV_PAR03

		If lDanfe

			If SE1->E1_ZZEMIBO == "S"
				DbSkip()
				Loop
			EndIf

		EndIf

		If  SE1->E1_PREFIXO # MV_PAR01 .Or. SE1->E1_TIPO == "NCC"
			SE1->(DbSkip())
			Loop
		EndIf

		If Alltrim(SE1->E1_NUM) < Alltrim(MV_PAR02) .Or. Alltrim(SE1->E1_NUM) > Alltrim(MV_PAR03)
			SE1->(DbSkip())
			Loop
		EndIf

		If SE1->E1_SALDO == 0
			SE1->(DbSkip())
			Loop
		EndIf


		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))

		If !SA1->A1_ZZBOL $ "S/P"
			SE1->(DbSkip())
			Loop
		EndIf

		If SA1->A1_ZZBOL == "P" .And. SA1->A1_BCO1 == "999" //Carteira
			SE1->(DbSkip())
			Loop
		EndIf 

		If Empty(SE1->E1_AGEDEP) .Or. Empty(SE1->E1_CONTA) .Or. Empty(SE1->E1_PORTADO)

			aBco := SelBcoDia()

			If Empty(aBco[1])
				MsgStop("Nao foi definido o Banco do dia...")
				Return
			EndIf
			cBanco   := aBco[1]
			cAgencia := aBco[2]+Space(5 - Len(aBco[2]))
			cNumCon  := If(cBanco="341",Substr(aBco[3],1,5),aBco[3])


		Else

			cBanco   := SE1->E1_PORTADO
			cAgencia := SE1->E1_AGEDEP
			cNumCon  := If(SE1->E1_PORTADO="341",Substr(SE1->E1_CONTA,1,5),SE1->E1_CONTA)

		EndIf

		//Posiciona na Arq de Parametros CNAB
		DbSelectArea("SEE")
		DbSetOrder(1)
		If !DbSeek(xFilial("SEE")+cBanco+cAgencia+cNumCon )
			MsgStop("Banco nao existe nos parametros Bancarios, nao sera gerado Boleto" )
			DbSelectArea("SE1")
			DbSkip()
			Loop
		EndIf

		cBcoCorres := ""
		lBcoCorres := .F.

		If SEE->EE_CODIGO == "033"
			cBcoAg := Substr(SEE->EE_AGENCIA,1,4)
		ElseIf SEE->EE_CODIGO == "237"
			cBcoAg := Substr(SEE->EE_AGENCIA,2,4)
		Else
			cBcoAg  := StrTran(SEE->EE_AGENCIA,"-","")
		EndIf
		cBcoCon := Alltrim(SEE->EE_CODEMP)

		cLogoBco := ""

		If !lBcoCorres
			If cBanco == "237"

				aDadosBanco  := {SEE->EE_CODIGO  ,;	// [1]Numero do Banco
				"Bradesco"     ,;	// [2]Nome do Banco (LOGO)
				cBcoAg 		   ,;	// [3]Agência
				cNumCon		   ,;	// [4]Conta Corrente
				SEE->EE_DVCTA  ,;
				Substr(SEE->EE_ZZCARTE,2,2)   ,;
				Substr(SEE->EE_ZZCARTE,2,2) }				    		 	// [5]Codigo da Carteira
				cDigBco := "2"

			ElseIf cBanco == "341"

				aDadosBanco  := {cBanco  ,;	// [1]Numero do Banco
				"Banco Itau S/A"         ,;	// [2]Nome do Banco (LOGO)
				cBcoAg 		  ,;	// [3]Agência
				Alltrim(cNumCon) ,;	// [4]Conta Corrente
				SEE->EE_DVCTA   ,;
				SEE->EE_ZZCARTE    ,;
				SEE->EE_ZZCARTE}				    		 	// [5]Codigo da Carteira
				cDigBco := "7"

			ElseIf cBanco == "033"
				aDadosBanco  := {cBanco  ,;               //1-Numero do Banco
				"Banco Santander "    ,;               //2-Nome do Banco
				cBcoAg ,;   //3-Agência
				Conta(cBanco, SEE->EE_CONTA),;   //4-Conta Corrente
				SEE->EE_DVCTA  ,;               //5-Dígito da conta corrente
				SEE->EE_ZZCARTE ,;
				SEE->EE_ZZCARTE   ,;
				""  }

				cDigBco := "7"

			ElseIf cBanco == "001"
				aDadosBanco  := {cBanco  ,;            //1-Numero do Banco
				"Banco do Brasil"    ,;               //2-Nome do Banco
				cBcoAg ,;   //3-Agência
				SEE->EE_CONTA,;   //4-Conta Corrente
				SEE->EE_DVCTA  ,;               //5-Dígito da conta corrente
				Substr(SEE->EE_ZZCARTE,2,2) ,;
				Substr(SEE->EE_ZZCARTE,2,2)  ,;
				""  }

				cDigBco := "9"

			ElseIf cBanco == "422"
				aDadosBanco  := {cBanco  ,;            //1-Numero do Banco
				"Banco Safra SA"    ,;               //2-Nome do Banco
				cBcoAg ,;   //3-Agência
				SEE->EE_CONTA,;   //4-Conta Corrente
				SEE->EE_DVCTA  ,;               //5-Dígito da conta corrente
				SEE->EE_ZZCARTE ,;
				SEE->EE_ZZCARTE   ,;
				""  }

				cDigBco := "7"

			EndIf

		EndIf

		//Posiciona o SA6 (Bancos)
		DbSelectArea("SA6")
		DbSetOrder(1)
		DbSeek(xFilial("SA6")+cBanco+cAgencia+cNumCon )

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
		//
		If Empty(SA1->A1_ENDCOB)
			aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;     // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
			AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
			AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
			SA1->A1_EST                                       ,;     // [5]Estado
			SA1->A1_CEP                                       ,;     // [6]CEP
			SA1->A1_CGC									  	  ,;     // [7]CGC
			IIF(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
			Alltrim(SA1->A1_EMAIL)						  	  }      // [9]EMAIL
		Else
			aDatSacado   := {AllTrim(SA1->A1_NOME)              ,;   // [1]Razão Social
			AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
			AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
			AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
			SA1->A1_ESTC	                                      ,;   // [5]Estado
			SA1->A1_CEPC                                         ,;   // [6]CEP
			SA1->A1_CGC									  	  ,;     // [7]CGC
			IIF(SA1->(FieldPos("A1_BLEMAIL"))<>0,SA1->A1_BLEMAIL,""),;  // [8]BOLETO por EMAIL
			Alltrim(SA1->A1_EMAIL)						  	  }      // [9]EMAIL
		Endif

		DbSelectArea("SE1")

		If Empty(SE1->E1_PARCELA)
			cParcela:= " " // "000"
		Else
			cParcela:= StrZero(Val(Trim(SE1->E1_PARCELA)),3)
		EndIf

		If cBanco == "237" .Or. cBcoCorres == "237"
			_cNossoNum := U_nossonr(lBcoCorres)
		ElseIf cBanco == "341" .Or. cBcoCorres == "341"
			If !Empty(SE1->E1_NUMBCO)
				_cNossoNum := Alltrim(SE1->E1_NUMBCO)
			Else
				_cNossoNum := U_NumItau() //Gera o sequencial do Banco Itau..
			EndIf
		ElseIf cBanco == "033"
			_cNossoNum := U_NumSantand()
		ElseIf cBanco == "001"
			_cNossoNum := U_NumBcoBrasil()
		ElseIf cBanco == "422"
			If !Empty(SE1->E1_NUMBCO)
				_cNossoNum := Alltrim(SE1->E1_NUMBCO)
			Else
				_cNossoNum := U_NumSafra() //Gera o sequencial do Banco Itau..
			EndIf
		Else
			_cNossoNum := strzero(Val(Alltrim(SE1->E1_NUM)),9) + cParcela //Composicao Filial + Titulo + Parcela
		EndIf

		_nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
		_nVlrDesc   := SE1->E1_SALDO*(SE1->E1_DESCFIN/100)

		If cBanco == "237" .Or. cBcoCorres == "237"
			CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_SALDO ),Datavalida(SE1->E1_VENCREA,.T.),aDadosBanco[7])
		ElseIf cBanco == "341" .Or. cBcoCorres == "341"
			CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),Alltrim(aDadosBanco[4]),aDadosBanco[5],AllTrim(_cNossoNum),(SE1->E1_SALDO - SE1->E1_DECRESC ),Datavalida(SE1->E1_VENCREA,.T.),aDadosBanco[6])
		ElseIf cBanco == "033"
			If Len(Alltrim(_cNossonum)) < 13
				_cNossoNum := StrZero(Val(_cNossoNum),13)
			EndIf
			CB_RN_NN :=Ret_Bar033(aDadosBanco[1] , Alltrim(_cNossoNum) , (SE1->E1_SALDO-_nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon )
		ElseIf cBanco == "001"
			CB_RN_NN :=Ret_Bar001(aDadosBanco[1] , Alltrim(_cNossoNum) , (SE1->E1_SALDO-_nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon )

		ElseIf cBanco == "422"
			CB_RN_NN :=Ret_Bar422(aDadosBanco[1] , Alltrim(_cNossoNum) , (SE1->E1_SALDO-_nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon, SEE->EE_TPCOBR )

		Else
			CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",Subs(aDadosBanco[3],1,4),aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),SE1->E1_SALDO ,Datavalida(SE1->E1_VENCREA,.T.),aDadosBanco[6])
		EndIf

		aDadosTit   := {Alltrim(SE1->E1_NUM)+Alltrim(cParcela)						,;  // [1] Número do título
		ArrumaAno(SE1->E1_EMISSAO,.T.)                 					,;  // [2] Data da emissão do título
		ArrumaAno(Date())                   					,;  // [3] Data da emissão do boleto
		ArrumaAno(SE1->E1_VENCREA)      					,;  // [4] Data do vencimento
		(SE1->E1_SALDO - SE1->E1_DECRESC )                  					,;  // [5] Valor do título //- _nVlrAbat - _nVlrDesc
		CB_RN_NN[3]		                         					,;  // [6] Nosso número (Ver fórmula para calculo)
		SE1->E1_PREFIXO                               					,;  // [7] Prefixo da NF
		"NF"	                               						}   // [8] Tipo do Titulo
		//

		//Mensagem para o Titulos   

		aBolText     := {" APÓS O VENCIMENTO MULTA DE R$ "+Alltrim(Transform((aDadosTit[5]*2)/100,"@E 999,999,999.99")),;
		" APÓS O VENCIMENTO, COBRAR MORA DE R$ "+Alltrim(transform((aDadosTit[5]*0.33)/100,"@E 999.99"))+" AO DIA"    ,;
		"Protestar apos 5 (cinco) dias corridos do vencimento"}

		Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
		n := n + 1

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_ZZEMIBO  := "S"
		If Empty(SE1->E1_NUMBCO)
			SE1->E1_NUMBCO  := _cNossoNum  // Nosso número (Ver fórmula para calculo)
		EndIf
		SE1->E1_PORTADO	:= cBanco
		SE1->E1_AGEDEP 	:= cAgencia
		SE1->E1_CONTA   := cNumCon
		//SE1->E1_SITUACA	:=	Substr(aDadosBanco[6],2,1)
		MsUnlock()

		DbSkip()

	EndDo

	oPrint:Preview()

	If lEmail .and. !Empty(cJPEG)
		oPrint:SaveAllAsJPEG(cStartPath+cJPEG,870,1270,140)
	EndIf

	oPrint:End()

	If lEmail .and. !Empty(cJPEG)

		EnviaEmail(cJPEG)

	EndIF

	If lEmail
		//	Deleta arquivos JPEG gerados pelos relatorios.
		FErase( cStartPath+cJPEG )
	EndIf

	oPrint:End()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REIMPBOL  ºAutor  ³Microsiga           º Data ³  08/15/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SelBcoBol()
	Local cBanco := Space(3)
	Local aArea := GetArea()
	Local lRet := .F.

	nOpca := 0

	DEFINE MSDIALOG oDlgProc TITLE "Banco Boleto " From 9,0 To 18,40 OF oMainWnd

	@ 5,3 to 41,155 of oDlgProc PIXEL

	@ 15,5 Say "Digite Banco: " Size 50,10  of oDlgProc Pixel
	@ 13,45 MSGet cBanco F3 "SA6" Valid ChkBco(@cBanco) Size 30,10 of oDlgProc Pixel

	@ 50, 90 BMPBUTTON TYPE 1 Action FecBco(oDlgProc,cBanco)
	@ 50,120 BMPBUTTON TYPE 2 Action Close(oDlgProc)

	ACTIVATE MSDIALOG oDlgProc Centered

	If !Empty(cBanco)
		lRet := .T.
	EndIf

	RestArea(aArea)

Return lRet


Static Function ChkBco(cBanco)

	SA6->(DbSetOrder(1))
	If !SA6->(DbSeek(xFilial("SA6")+cBanco))
		MsgStop("Banco nao Cadastrado..")
		Return .F.
	EndIf

Return .T.

Static Function FecBco(oDlgProc,cBanco,lRet)

	If !Empty(cBanco)
		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_PORTADO := cBanco
		MsUnlock()
	EndIf

	Close(oDlgProc)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Impress      ³Descri‡ão³Impressao de Boleto Grafico do Banco³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	LOCAL _nTxper := GETMV("MV_TXPER")
	LOCAL nDacNN
	LOCAL oFont2n
	LOCAL oFont8
	LOCAL oFont9
	LOCAL oFont10
	LOCAL oFont15n
	LOCAL oFont16
	LOCAL oFont16n
	LOCAL oFont14n
	LOCAL oFont24
	LOCAL i := 0
	LOCAL aCoords1 := {0150,1900,0550,2300}
	LOCAL aCoords2 := {0450,1050,0550,1900}
	LOCAL aCoords3 := {0710,1900,0810,2300}
	LOCAL aCoords4 := {0980,1900,1050,2300}
	LOCAL aCoords5 := {1330,1900,1400,2300}
	LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
	LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
	LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
	LOCAL oBrush
	//

	If cBanco == "033"
		aDadosBanco[4] := Alltrim(SEE->EE_CONTA) //Alltrim(SEE->EE_CONVENI)
	EndIf

	If Valtype(aBitmap) == "C" .And. Len(aBitmap) > 0
		aBmp:= aBitMap
	Else
		aBmp := "BANCO.BMP"
	EndIf
	aBmp2 	:= "LOGO.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	//
	oBrush := TBrush():New("",5)//4
	//
	oPrint:StartPage()   // Inicia uma nova página

	If cBanco == "033"
		oPrint:SayBitMap(0054,100,"\bmpbanco\santander.bmp",370,100)	// [2]Nome do Banco (LOGO)
		//oPrint:Say  (nRow1+0075,513,aDadosBanco[1]+"-7",oFont21 )		// [1]Numero do Banco
	Else
		oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
	EndIf

	If !lBcoCorres
		cAgCC := LEFT(aDadosBanco[3],4)
		If !Empty(SA6->A6_DVAGE)
			cAgCC += "-"+SA6->A6_DVAGE
		EndIf
	Else
		If cBanco == "341"
			cAgCC := LEFT(aDadosBanco[3],4)
		Else
			cAgCC := LEFT(aDadosBanco[3],4)+"-"+SEE->EE_DGAGCOR
		EndIf
	EndIf

	If cBanco == "341"
		cConta := Alltrim(aDadosBanco[4])+"-"+aDadosBanco[5]
	ElseIf cBanco == "033"
		cConta := SEE->EE_CODEMP 
	Else
		cConta := StrZero(Val(aDadosBanco[4]),8)+"-"+aDadosBanco[5] //If(cBanco#"033","-"+aDadosBanco[5],"")
	EndIf

	oPrint:Say  (0084,1860,"Comprovante de Entrega",oFont10)
	oPrint:Line (0150,100,0150,2300)
	oPrint:Say  (0150,100 ,"Beneficiario"                                        ,oFont8)
	If !lBcoCorres
		oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont8) //Nome + CNPJ
	Else
		oPrint:Say  (0200,100 ,SA6->A6_NOME               	,oFont10) //Nome + CNPJ
	EndIf
	oPrint:Say  (0150,1060,"Agência/Código do Beneficiario"                         ,oFont8)
	oPrint:Say  (0200,1060,cAgCC+"/"+cConta,oFont10)
	oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
	oPrint:Say  (0200,1510,(alltrim(aDadosTit[7]))+aDadosTit[1]      		,oFont10) //Numero+Parcela
	oPrint:Say  (0250,100 ,"Pagador"                                         ,oFont8)
	oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome
	oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
	oPrint:Say  (0300,1060,aDadosTit[4]			                               ,oFont10)
	oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
	oPrint:Say  (0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
	oPrint:Say  (0400,0100,"Recebi(emos) o bloqueto/título"                 ,oFont10)
	oPrint:Say  (0450,0100,"com as características acima."             		,oFont10)
	oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
	oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
	oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
	oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)
	//
	oPrint:Line (0250, 100,0250,1900 )
	oPrint:Line (0350, 100,0350,1900 )
	oPrint:Line (0450,1050,0450,1900 )
	oPrint:Line (0550, 100,0550,2300 )
	//
	oPrint:Line (0550,1050,0150,1050 )
	oPrint:Line (0550,1400,0350,1400 )
	oPrint:Line (0350,1500,0150,1500 )
	oPrint:Line (0550,1900,0150,1900 )
	//
	oPrint:Say  (0165,1910,"(  ) Mudou-se"                                	,oFont8)
	oPrint:Say  (0205,1910,"(  ) Ausente"                                   ,oFont8)
	oPrint:Say  (0245,1910,"(  ) Não existe nº indicado"                  	,oFont8)
	oPrint:Say  (0285,1910,"(  ) Recusado"                                	,oFont8)
	oPrint:Say  (0325,1910,"(  ) Não procurado"                             ,oFont8)
	oPrint:Say  (0365,1910,"(  ) Endereço insuficiente"                  	,oFont8)
	oPrint:Say  (0405,1910,"(  ) Desconhecido"                            	,oFont8)
	oPrint:Say  (0445,1910,"(  ) Falecido"                                  ,oFont8)
	oPrint:Say  (0485,1910,"(  ) Outros(anotar no verso)"                  	,oFont8)
	//
	For i := 100 to 2300 step 50
		oPrint:Line( 0590, i, 0590, i+30)
	Next i
	//

	// Inicia o Recido do Sacado

	If cBanco # "341"
		oPrint:Line (0710,100,0710,2300)
		oPrint:Line (0710,550,0610, 550)
		oPrint:Line (0710,800,0610, 800)
		//
		// LOGOTIPO
		If aDadosBanco[1] == "033"
			oPrint:SayBitMap(0580,100,"\bmpbanco\santander.bmp",370,100)	// [2]Nome do Banco (LOGO)

		Else
			If File(alltrim(aDadosBanco[1])+aBmp).And. aDatSacado[8] <> "1"
				oPrint:SayBitmap( 0600,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
				//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
				Do Case
					Case Len(aDadosBanco[2]) < 17
					oPrint:Say  (0640,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
					Case Len(aDadosBanco[2]) < 19
					oPrint:Say  (0640,240,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
					OtherWise
					oPrint:Say  (0640,240,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
				EndCase
			Else
				//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
				Do Case
					Case Len(aDadosBanco[2]) < 13
					oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
					Case Len(aDadosBanco[2]) < 17
					oPrint:Say  (0644,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
					OtherWise
					If Len(aDadosBanco[2]) > 25
						oPrint:Say  (0644,100,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco
					Else
						oPrint:Say  (0644,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
					EndIf
				EndCase
			EndIf
		EndIf
		//
		oPrint:Say  (0618,569,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco
		oPrint:Say  (0644,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
		//
		oPrint:Line (0810,100,0810,2300 )
		oPrint:Line (0910,100,0910,2300 )
		oPrint:Line (0980,100,0980,2300 )
		oPrint:Line (1050,100,1050,2300 )
		//
		oPrint:Line (0910,500,1050,500)
		oPrint:Line (0980,750,1050,750)
		oPrint:Line (0910,1000,1050,1000)
		oPrint:Line (0910,1350,0980,1350)
		oPrint:Line (0910,1550,1050,1550)
		//
		oPrint:Say  (0710,100 ,"Local de Pagamento"                             					,oFont8)

		If cBanco == "341"
			oPrint:Say  (0730,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont9)
			oPrint:Say  (0770,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco
		ElseIf cBanco == "237"
			oPrint:Say  (0730,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso"        			,oFont9)
			//		oPrint:Say  (0770,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco

		Else
			oPrint:Say  (0730,400 ,"Pagável em qualquer Banco até o Vencimento."        		   		,oFont9)
			oPrint:Say  (0770,400 ,"Após o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+"."   ,oFont9) //Nome do banco
		EndIf
		//
		oPrint:Say  (0710,1910,"Vencimento"                               ,oFont8)
		oPrint:Say  (0750,2010,aDadosTit[4]                               ,oFont10)
		//
		If cBanco = "341"
			oPrint:Say  (0810,100 ,"Beneficiario"                            ,oFont8)
		Else
			oPrint:Say  (0810,100 ,"Cedente"                                 ,oFont8)
		EndIf
		If !lBcoCorres
			If cBanco == "237"
				oPrint:Say  (0850,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC+"-"+Alltrim(aDadosEmp[2])+"-"+Alltrim(aDadosEmp[3])  	,oFont8) //Nome + CNPJ
			Else
				oPrint:Say  (0850,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC  	,oFont10) //Nome + CNPJ
			EndIf
		Else
			oPrint:Say  (0850,100 ,SA6->A6_NOME               	,oFont10) //Nome + CNPJ
		EndIf

		//oPrint:Say  (0850,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
		//

		oPrint:Say  (0810,1910,"Agência/Código Beneficiario"                         ,oFont8)
		oPrint:Say  (0850,2010,cAgCC+"/"+cConta,oFont10)

		//
		oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
		oPrint:Say  (0940,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
		//
		oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
		If cBanco == "001"
			oPrint:Say  (0940,605 ,Transform(aDadosTit[1],"@R 999999999/999")     ,oFont10) //Numero+Parcela
		Else
			oPrint:Say  (0940,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]         ,oFont10) //Numero+Parcela
		EndIf
		//
		oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
		oPrint:Say  (0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
		//
		oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
		oPrint:Say  (0940,1455,"N"                                             ,oFont10)
		//
		oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
		oPrint:Say  (0940,1655,aDadosTit[3]                               ,oFont10) // Data impressao
		//
		nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
		nDacNN:= IIF(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
		oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)

		If cBanco == "033"
			oPrint:Say  (0940,1970,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		ElseIf cBanco == "001"
			oPrint:Say  (0940,1970,cBcoCon+_cNossoNum	,oFont10) //+"-"+Alltrim( nDacNN
		ElseIf cBanco == "341"
			oPrint:Say  (0940,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 99999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
		Else
			If Len(Alltrim(aDadosTit[6])) < 10
				oPrint:Say  (0940,2000,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			ElseIf Len(Alltrim(aDadosTit[6])) > 12
				oPrint:Say  (0940,1970,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 999999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			Else
				oPrint:Say  (0940,1990,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
			EndIf
		EndIf
		//
		oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)
		//
		oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
		oPrint:Say  (1010,555 ,If(cBanco=="033","RCR",aDadosBanco[7])          	,oFont10)
		//
		oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
		oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)
		//
		oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
		oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)
		//
		oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
		oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
		//
		If cBanco == "341"
			oPrint:Say  (1050,100 ,"Instrucoes de responsabilidade do beneficiário. qualquer dúvida sobre este boleto, contate o benefifiário.",ofont8)
		Else
			oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
		EndIf
		oPrint:Say  (1150,100 ,aBolText[1]                                        ,oFont10)
		oPrint:Say  (1200,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)
		oPrint:Say  (1250,100 ,aBolText[3]                                        ,oFont10)
		//
		oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
		oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
		oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
		oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
		oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)
		//
		oPrint:Say  (1400,100 ,"Pagador"                                         ,oFont8)
		If cBanco == "001"
			oPrint:Say  (1410,400 ,aDatSacado[1]+" ("+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")+")"             ,oFont10)
		Else
			oPrint:Say  (1410,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
		EndIf
		oPrint:Say  (1463,400 ,aDatSacado[3]                                    ,oFont10)
		oPrint:Say  (1506,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
		if Len(Alltrim(aDatSacado[7])) == 14
			If cBanco == "001"
				//		oPrint:Say  (1410,1850 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
			Else
				oPrint:Say  (1549,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
			EndIf
		else
			oPrint:Say  (1549,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
		endif
		oPrint:Say  (1559,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
		//
		oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
		If lBcocorres
			oPrint:Say  (1605,400 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont8) //Nome + CNPJ
		EndIf
		oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)
		oPrint:Say  (1645,1850,"Recibo do Sacado"								,oFont10)
		//
		oPrint:Line (0710,1900,1400,1900 )
		oPrint:Line (1120,1900,1120,2300 )
		oPrint:Line (1190,1900,1190,2300 )
		oPrint:Line (1260,1900,1260,2300 )
		oPrint:Line (1330,1900,1330,2300 )
		oPrint:Line (1400,100 ,1400,2300 )
		oPrint:Line (1640,100 ,1640,2300 )
		//
		For i := 100 to 2300 step 50
			oPrint:Line( 1930, i, 1930, i+30)                 // 1850
		Next i
		//
		oPrint:Line (2080,100,2080,2300)                                                       //   2000
		oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
		oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900

	Else // Recibo do Itau

		oPrint:Line (0710,100,0710,2300)
		oPrint:Line (0710,550,0610, 550)
		oPrint:Line (0710,800,0610, 800)
		//
		// LOGOTIPO
		If File(alltrim(aDadosBanco[1])+aBmp).And. aDatSacado[8] <> "1"
			oPrint:SayBitmap( 0600,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
			//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
				Case Len(aDadosBanco[2]) < 17
				oPrint:Say  (0640,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
				Case Len(aDadosBanco[2]) < 19
				oPrint:Say  (0640,240,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
				OtherWise
				oPrint:Say  (0640,240,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
			EndCase
		Else
			//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
				Case Len(aDadosBanco[2]) < 13
				oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
				Case Len(aDadosBanco[2]) < 17
				oPrint:Say  (0644,100,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
				OtherWise
				If Len(aDadosBanco[2]) > 25
					oPrint:Say  (0644,100,Subs(aDadosBanco[2],1,25),oFont9 )	// [2]Nome do Banco
				Else
					oPrint:Say  (0644,100,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
				EndIf
			EndCase
		EndIf

		//
		oPrint:Say  (0618,569,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco
		oPrint:Say  (0644,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
		//
		oPrint:Line (0810,100,0810,2300 )
		oPrint:Line (0910,100,0910,2300 )
		oPrint:Line (0980,100,0980,2300 )
		oPrint:Line (1050,100,1050,2300 )
		oPrint:Line (1120,100,1120,2300 )
		//                               
		oPrint:Line (0810,1350,0910,1350 )
		oPrint:Line (0980,500,1120,500)
		oPrint:Line (1050,750,1120,750)
		oPrint:Line (0980,1000,1120,1000)
		oPrint:Line (0980,1350,1050,1350)
		oPrint:Line (0980,1550,1120,1550)
		//
		oPrint:Say  (0710,100 ,"Local de Pagamento"                             					,oFont8)


		oPrint:Say  (0730,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont10)
		oPrint:Say  (0770,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont10) //Nome do Banco
		//
		oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
		oPrint:Say  (0750,2010,aDadosTit[4]                               ,oFont10)
		//
		oPrint:Say  (0810,100  ,"Beneficiario"                                        ,oFont8)
		oPrint:Say  (0810,1100 ,"CNPJ"                                        ,oFont8)
		If !lBcoCorres
			oPrint:Say  (0850,100 ,aDadosEmp[1]  	,oFont8) //Nome + CNPJ
			oPrint:Say  (0850,1100 ,Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")  	,oFont8) //Nome + CNPJ
		Else
			oPrint:Say  (0850,100 ,SA6->A6_NOME                   	,oFont10) //Nome + CNPJ
		EndIf

		oPrint:Say  (0810,1355 ,"Sacador/Avalista"                                        ,oFont8)

		oPrint:Say  (0810,1910,"Agência/Código Beneficiario"                         ,oFont8)
		oPrint:Say  (0850,2010,cAgCC+"/"+cConta,oFont10)
		//

		oPrint:Say  (0910,100 ,"Endereço Beneficiario"                              ,oFont8)

		cEndBene := Alltrim(SM0->M0_ENDCOB)+"-"+Alltrim(SM0->M0_BAIRCOB)+"-"+Alltrim(SM0->M0_CIDCOB)+"-"+Alltrim(SM0->M0_ESTCOB)

		oPrint:Say  (0940,100 ,cEndBene                             ,oFont10)

		oPrint:Say  (0980,100 ,"Data do Documento"                              ,oFont8)
		oPrint:Say  (1010,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
		//
		oPrint:Say  (0980,505 ,"Nro.Documento"                                  ,oFont8)
		oPrint:Say  (1010,605 ,Transform(aDadosTit[1],"@R 999999999/999")         ,oFont10) //Numero+Parcela

		//
		oPrint:Say  (0980,1005,"Espécie Doc."                                   ,oFont8)
		oPrint:Say  (1010,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
		//
		oPrint:Say  (0980,1355,"Aceite"                                         ,oFont8)
		oPrint:Say  (1010,1455,"N"                                             ,oFont10)
		//
		oPrint:Say  (0980,1555,"Data do Processamento"                          ,oFont8)
		oPrint:Say  (1010,1655,aDadosTit[3]                                     ,oFont10) // Data impressao
		//
		nDacNN:= DACNN(aDadosBanco[6]+aDadosTit[6])
		nDacNN:= IIF(ValType(nDacNN) == "N",Alltrim(Str(nDacNN)),nDacNN)
		oPrint:Say  (0980,1910,"Nosso Número"                                   ,oFont8)

		oPrint:Say  (1010,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 99999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
		//
		oPrint:Say  (1050,100 ,"Uso do Banco"                                   ,oFont8)
		//
		oPrint:Say  (1050,505 ,"Carteira"                                       ,oFont8)
		oPrint:Say  (1080,555 ,aDadosBanco[7]                       	,oFont10)
		//
		oPrint:Say  (1050,755 ,"Espécie"                                        ,oFont8)
		oPrint:Say  (1080,805 ,"R$"                                             ,oFont10)
		//
		oPrint:Say  (1050,1005,"Quantidade"                                     ,oFont8)
		oPrint:Say  (1050,1555,"Valor"                                          ,oFont8)
		//
		oPrint:Say  (1050,1910,"Valor do Documento"                          	,oFont8)
		oPrint:Say  (1080,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
		//

		oPrint:Say  (1145,1450,"Autenticação Mecânica -"                        ,oFont8)
		oPrint:Say  (1645,1850,"Recibo do Pagador"								,oFont10)
		//
		oPrint:Line (0710,1900,910,1900 )
		oPrint:Line ( 980,1900,1120,1900 )
		oPrint:Line (1120,1900,1120,2300 )

		oPrint:Line (1140,1200 ,1140,2100 )
		oPrint:Line (1140,1200 ,1170,1200 )
		oPrint:Line (1140,2100 ,1170,2100 )
		//
		For i := 100 to 2300 step 40
			oPrint:Line( 1930, i, 1930, i+30)                 // 1850
		Next i
		//
		oPrint:Line (2080,100,2080,2300)                                                       //   2000
		oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
		oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900

	EndIf

	//
	//Ficha de compensacao
	// LOGOTIPO
	If aDadosBanco[1] == "033"
		oPrint:SayBitMap(1960,100,"\bmpbanco\santander.bmp",370,100)	// [2]Nome do Banco (LOGO)


	Else
		If File(alltrim(aDadosBanco[1])+aBmp).And. aDatSacado[8] <> "1"
			oPrint:SayBitmap( 1970,0100,alltrim(aDadosBanco[1])+aBmp,0100,0100 )
			//	Fonte 10 suporta somente 16 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
				Case Len(aDadosBanco[2]) < 17
				oPrint:Say  (2010,240,aDadosBanco[2],oFont10 )	// [2]Nome do Banco
				Case Len(aDadosBanco[2]) < 19
				oPrint:Say  (2010,240,aDadosBanco[2],oFont9 )	// [2]Nome do Banco
				OtherWise
				oPrint:Say  (2010,240,aDadosBanco[2],oFont8 )	// [2]Nome do Banco
			EndCase
		Else
			//	Fonte 15 suporta somente 12 caracteres no layout deste boleto se exceder deve-se diminuir a fonte para caber
			Do Case
				Case Len(aDadosBanco[2]) < 13
				oPrint:Say  (2014,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
				Case Len(aDadosBanco[2]) < 17
				oPrint:Say  (2014,100,aDadosBanco[2],oFont10 )		// [2]Nome do Banco                     1934
				OtherWise
				If Len(aDadosBanco[2]) > 25
					oPrint:Say  (2014,100,Subs(aDadosBanco[2],1,25),oFont9 ) 		// [2]Nome do Banco                     1934
				Else
					oPrint:Say  (2014,100,aDadosBanco[2],oFont9 ) 					// [2]Nome do Banco                     1934
				EndIf
			EndCase
		EndIf
	EndIf
	//
	oPrint:Say  (1988,569,aDadosBanco[1]+"-"+cDigBco ,oFont24 )	// [1]Numero do Banco                       1912
	oPrint:Say  (2014,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
	//
	oPrint:Line (2180,100,2180,2300 )
	oPrint:Line (2280,100,2280,2300 )
	oPrint:Line (2350,100,2350,2300 )
	oPrint:Line (2420,100,2420,2300 )
	//
	oPrint:Line (2280, 500,2420,500)
	oPrint:Line (2350, 750,2420,750)
	oPrint:Line (2280,1000,2420,1000)
	oPrint:Line (2280,1350,2350,1350)
	oPrint:Line (2280,1550,2420,1550)
	//
	oPrint:Say  (2080,100 ,"Local de Pagamento"                             				,oFont8)
	If cBanco = "341"

		oPrint:Say  (2100,400 ,"Até o Vencimento, preferencialmente no Itau."        			,oFont9)
		oPrint:Say  (2140,400 ,"Após o Vencimento, somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco

	ElseIf cBanco = "237"

		oPrint:Say  (2100,400 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso"        			,oFont9)

	Else
		oPrint:Say  (2100,400 ,"Pagável em qualquer Banco até o Vencimento."        			,oFont9)
		oPrint:Say  (2140,400 ,"Após o Vencimento pague somente no "+Alltrim(aDadosBanco[2])+".",oFont9) //Nome do Banco
	EndIf
	//
	oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont8)
	oPrint:Say  (2120,2010,aDadosTit[4]                               ,oFont10)
	//
	oPrint:Say  (2180,100 ,"Beneficiario"                                        ,oFont8)
	If !lBcoCorres
		If cBanco == "237"
			oPrint:Say  (2220,100 ,aDadosEmp[1]+"-"+SM0->M0_CGC+"-"+Alltrim(aDadosEmp[2])+"-"+Alltrim(aDadosEmp[3])  	,oFont8) //Nome + CNPJ
		Else
			oPrint:Say  (2220,100 ,aDadosEmp[1]+"- "+SM0->M0_CGC        	,oFont10) //Nome + CNPJ
		EndIf
	Else
		oPrint:Say  (2220,100 ,SA6->A6_NOME               	,oFont10) //Nome + CNPJ
	EndIf

	//oPrint:Say  (2220,100 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
	//
	oPrint:Say  (2180,1910,"Agência/Código do Beneficiario"                         ,oFont8)
	oPrint:Say  (2220,2010,cAgCC+"/"+cConta,oFont10)
	//
	oPrint:Say  (2280,100 ,"Data do Documento"                              ,oFont8)
	oPrint:Say  (2310,100 ,aDadosTit[2]                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
	//
	oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont8)
	If cBanco == "001"
		oPrint:Say  (2310,605 , Transform(aDadosTit[1],"@R 999999999/999") 		,oFont10) // Numero+Parcela _cNossoNum
	Else
		oPrint:Say  (2310,605 ,Transform(aDadosTit[1],"@R 999999999/999")		,oFont10) // Numero+Parcela
	EndIf
	//
	oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont8)
	oPrint:Say  (2310,1050,aDadosTit[8]										,oFont10) // Tipo do Titulo
	//
	oPrint:Say  (2280,1355,"Aceite"                                         ,oFont8)  // 2200
	oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230
	//
	oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont8)       // 2200
	oPrint:Say  (2310,1655,aDadosTit[3]                                     ,oFont10) // Data impressao  2230
	//
	oPrint:Say  (2280,1910,"Nosso Número"                                   ,oFont8)       // 2200
	If cBanco == "033"
		//oPrint:Say  (2310,2000,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		oPrint:Say  (2310,1970,Transform(Right(aDadosTit[6],8),"@R 9999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
	ElseIf cBanco == "001"
		oPrint:Say  (2310,1970,cBcoCon+_cNossoNum	,oFont10) //+"-"+Alltrim( nDacNN
	ElseIf cBanco == "341"
		oPrint:Say  (2310,1970,aDadosBanco[7]+"/"+Transform(_cNossoNum,"@R 99999999-9")	,oFont10) //+"-"+Alltrim( nDacNN
	Else
		If Len(Alltrim(aDadosTit[6])) < 10
			oPrint:Say  (2310,2000,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999-X") ,oFont10)  // 2230 +aDadosTit[6]+"-"+Alltrim( nDacNN )
		ElseIf Len(Alltrim(aDadosTit[6])) > 12
			oPrint:Say  (2310,1970,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 999999999999-X")	,oFont10) //+"-"+Alltrim( nDacNN
		Else
			oPrint:Say  (2310,1990,aDadosBanco[7]+"/"+Transform(aDadosTit[6],"@R 99999999999-X") ,oFont10)  // 2230 +aDadosTit[6]+"-"+Alltrim( nDacNN )
		EndIf
	EndIf
	//
	oPrint:Say  (2350,100 ,"Uso do Banco"                                   ,oFont8)       // 2270
	//
	oPrint:Say  (2350,505 ,"Carteira"                                       ,oFont8)       // 2270
	oPrint:Say  (2380,555 ,If(cBanco=="033","RCR",aDadosBanco[7])         	,oFont10)      //  2300
	//
	oPrint:Say  (2350,755 ,"Espécie"                                        ,oFont8)       //  2270
	oPrint:Say  (2380,805 ,"R$"                                             ,oFont10)      //  2300
	//
	oPrint:Say  (2350,1005,"Quantidade"                                     ,oFont8)       //  2270
	oPrint:Say  (2350,1555,"Valor"                                          ,oFont8)       //  2270
	//
	oPrint:Say  (2350,1910,"Valor do Documento"                          	,oFont8)        //  2270
	oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300
	//
	If cBanco == "341"
		oPrint:Say  (2420,100 ,"INSTRUÇÕES DE RESPONSABILIDADE DO BENEFICIÁRIO. QUALQUER DÚVIDA SOBRE ESTE BOLETO, CONTATE O BENEFICIÁRIO.",ofont8)
	Else
		oPrint:Say  (2420,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8) // 2340
	EndIf

	oPrint:Say  (2470,100 ,aBolText[1]                                        ,oFont10)
	//	oPrint:Say  (2570,100 ,aBolText[2]+" "+AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99"))  ,oFont10)  // 2490  // *0.05)/30)
	oPrint:Say  (2520,100 ,aBolText[2]  ,oFont10)  // 2490  // *0.05)/30)
	oPrint:Say  (2570,100 ,aBolText[3]                                        ,oFont10)    //2540

	If SA1->A1_ZZCONTR > 0
		oPrint:Say  (2620,100 ," ATÉ "+DTOC(SE1->E1_VENCREA)+" DESCONTO DE "+Alltrim(transform(aDadosTit[5]*(SA1->A1_ZZCONTR)/100,"@E 999,999.99"))  ,oFont10)
	Endif                                                                     

	If cBanco == "341"
	   oPrint:Say  (2672,100 ," TELEFONE DE COBRANÇA (11) 3382-2944 RAMAL 2926/2908"  ,oFont10)	
	   oPrint:Say  (2720,100 ," Após VCTO ACESSE www.itau.com.br/servicos/boletos/atualizar/ para atulizar seu boleto"  ,oFont10)
	Else
	  oPrint:Say  (2672,100 ," TELEFONE DE COBRANÇA (11) 3382-2944 RAMAL 2926/2908"  ,oFont10)	   
	EndIf  
	//
	oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
	oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
	oPrint:Say  (2560,1910,"(+)/Multa"                                  ,oFont8)      //  2480
	oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
	oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620
	//
	oPrint:Say  (2770,100 ,"Pagador"                                         ,oFont8)
	If cBanco == "001"
		oPrint:Say  (2790,400 ,aDatSacado[1]+" ("+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99")+")"             ,oFont10)
	Else
		oPrint:Say  (2790,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
	EndIf
	oPrint:Say  (2833,400 ,aDatSacado[3]                                    ,oFont10)       // 2773
	oPrint:Say  (2896,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826
	IF LEN(Alltrim(aDatSacado[7])) == 14
		If cBanco == "001"
			//		oPrint:Say  (2790,1850 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
		Else
			oPrint:Say  (2939,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
		EndIf
	ELSE
		oPrint:Say  (2939,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF        2879
	ENDIF
	//oPrint:Say  (2939,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)         //  2879
	//
	oPrint:Say  (2975,100 ,"Sacador/Avalista"                               ,oFont8)
	oPrint:Say  (2975,1355,"CNPJ"                               ,oFont8)
	If lBcocorres
		oPrint:Say  (2975,400 ,aDadosEmp[1]+" - "+aDadosEmp[6]	,oFont8) //Nome + CNPJ
	EndIf

	oPrint:Say  (3015,1500,"Autenticação Mecânica -"                        ,oFont8)
	oPrint:Say  (3015,1850,"Ficha de Compensação"                           ,oFont10)      // 2935 + 280      = 3215
	//
	oPrint:Line (2080,1900,2770,1900 )
	oPrint:Line (2490,1900,2490,2300 )
	oPrint:Line (2560,1900,2560,2300 )
	oPrint:Line (2630,1900,2630,2300 )
	oPrint:Line (2700,1900,2700,2300 )
	oPrint:Line (2770,100 ,2770,2300 )
	//
	oPrint:Line (3010,100 ,3010,2300 )
	//
	If cBanco # "341"
		MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
	EndIf
	MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
	//
	oPrint:EndPage() // Finaliza a página

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
	LOCAL L,D,P := 0
	LOCAL B     := .F.
	L := Len(cData)
	B := .T.
	D := 0
	While L > 0
		P := Val(SubStr(cData, L, 1))
		If (B)
			P := P * 2
			If P > 9
				P := P - 9
			End
		End
		D := D + P
		L := L - 1
		B := !B
	End
	D := 10 - (Mod(D,10))
	If D = 10
		D := 0
	End
Return(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
	LOCAL L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 9
			P := 1
		End
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
		D := 1
	End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DACNN       ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11 para NN.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DACNN(cData)
	LOCAL L, D, P := 0
	L := Len(cdata)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		End
		L := L - 1
	End

	Do Case
		Case mod(D,11) == 1  // Se o Resto for 1 a subtracao sera 11 - 1 e resultara 10 - despresa-se o 0 e para 1 sempre considera P como DAC
		D := "P"
		Case mod(D,11) == 0  // Se o Resto for 0 nao efetua subtracao e atribui 0 ao DAC
		D := 0
		OtherWise   // Para as demais situacoes efetua a subtracao normalmente
		D := 11 - (mod(D,11))
	EndCase

Return(D)
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto, cCarteira)
	//
	LOCAL bldocnufinal := cNroDoc//strzero(val(cNroDoc),8)
	LOCAL blvalorfinal := IIF(TamSx3("E1_SALDO")[2] == 2, strzero((nValor*100),10), strzero(int(nValor*100),10) )
	LOCAL dvnn         := 0
	LOCAL dvcb         := 0
	LOCAL dv           := 0
	LOCAL NN           := ''
	LOCAL RN           := ''
	LOCAL CB           := ''
	LOCAL s            := ''
	LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)

	If Substr(cBanco,1,3)  == "237"

		//
		//-------- Definicao do NOSSO NUMERO
		NN	 := bldocnufinal
		s    := cCarteira + bldocnufinal
		dvnn := DACNN(s)// digito verifacador Carteira + Nosso Num
		DACNN:= AllTrim(IIF(ValType(dvnn) == "N",Str(dvnn),dvnn))
		//
		//	-------- Definicao do CODIGO DE BARRAS
		s    := cBanco + _cfator + blvalorfinal + SubS(cAgencia,1,4) + cCarteira + Substr(NN,1,11) + StrZero(Val(cConta),7) + "0"
		dvcb := modulo11(s)
		CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
		//
		//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
		//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		//
		// 	CAMPO 1:
		//	AAA	= Codigo do ban-co na Camara de Compensacao
		//	  B = Codigo da moeda, sempre 9
		//	CCC = Codigo da Carteira de Cobranca
		//	 DD = Dois primeiros digitos no nosso numero
		//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := cBanco + SubS(cAgencia,1,4) + SubS(cCarteira,1,1)
		dv   := modulo10(s)
		RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 2:
		//	DDDDDD = Restante do Nosso Numero
		//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		//	   FFF = Tres primeiros numeros que identificam a agencia
		//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := SubStr(cCarteira, 2, 1) + SubStr(NN,1,4) + SubStr(NN, 5, 5)
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 3:
		//	     F = Restante do numero que identifica a agencia
		//	GGGGGG = Numero da Conta + DAC da mesma
		//	   HHH = Zeros (Nao utilizado)
		//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		s    := SubStr(NN, 10, 2) + StrZero(Val(cConta),7) + "0"
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 4:
		//	     K = DAC do Codigo de Barras
		RN   := RN + AllTrim(Str(dvcb)) + '  '
		//
		// 	CAMPO 5:
		//	      UUUU = Fator de Vencimento
		//	VVVVVVVVVV = Valor do Titulo
		RN   := RN + _cfator + blvalorfinal
		//

	ElseIf Substr(cBanco,1,3) == "341"

		//
		//-------- Definicao do NOSSO NUMERO
		If cCarteira # "112"
			s    :=  cAgencia + Alltrim(cConta) + cCarteira + Substr(bldocnufinal,1,8)
			dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
		Else
			s    :=  cAgencia + Alltrim(cConta) + cCarteira + Substr(bldocnufinal,1,8)
			s1   := cCarteira + Substr(bldocnufinal,1,8)
			dvnn := modulo10(s1) // digito verifacador Agencia + Conta + Carteira + Nosso Num
		EndIf

		NN   := cNroDoc //cCarteira + bldocnufinal + '-' + AllTrim(Str(dvnn))

		//
		//	-------- Definicao do CODIGO DE BARRAS
		//      4      		4     	10      		3		   8   				 1	   				4   		 5         1      3
		s    := cBanco + _cfator + blvalorfinal + cCarteira + Substr(bldocnufinal,1,8) + AllTrim(Str(dvnn)) + cAgencia + AllTrim(cConta) + cDacCC + '000'
		dvcb := modulo11(s)
		CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
		//
		//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
		//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
		//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
		//
		// 	CAMPO 1:
		//	AAA	= Codigo do banco na Camara de Compensacao
		//	  B = Codigo da moeda, sempre 9
		//	CCC = Codigo da Carteira de Cobranca
		//	 DD = Dois primeiros digitos no nosso numero
		//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := cBanco + cCarteira + SubStr(bldocnufinal,1,2)
		dv   := modulo10(s)
		RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 2:
		//	DDDDDD = Restante do Nosso Numero
		//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
		//	   FFF = Tres primeiros numeros que identificam a agencia
		//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		//
		s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 3:
		//	     F = Restante do numero que identifica a agencia
		//	GGGGGG = Numero da Conta + DAC da mesma
		//	   HHH = Zeros (Nao utilizado)
		//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
		s    := SubStr(cAgencia, 4, 1) + Alltrim(cConta) + cDacCC + '000'
		dv   := modulo10(s)
		RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
		//
		// 	CAMPO 4:
		//	     K = DAC do Codigo de Barras
		RN   := RN + AllTrim(Str(dvcb)) + '  '
		//
		// 	CAMPO 5:
		//	      UUUU = Fator de Vencimento
		//	VVVVVVVVVV = Valor do Titulo
		RN   := RN + _cfator + blvalorfinal //StrZero(Int(nValor * 100),14-Len(_cfator))

	Else

		cCampoL := "9"+cBcoCon+cNroDoc+"0"+cCarteira

		cMoeda := "9"
		// ALERT(cCampoL)

		//Fator de Vencimento + Valor do titulo
		nFator := SE1->E1_VENCTO - CtoD("07/10/1997")
		cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

		cLivre := cBanco+cMoeda+cFatorValor+cCampoL

		// campo do codigo de barra
		cDigBarra := CALC_DB( cLivre )
		cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

		// composicao da linha digitavel
		cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
		cDig1    := DIGITO( cParte1 )
		cParte2  := Substr(cBarra,25,10)
		cDig2    := DIGITO( cParte2 )
		cParte3  := Substr(cBarra,35,10)
		cDig3    := DIGITO( cParte3 )
		cParte4  := cDigBarra
		cParte5  := cFatorValor

		cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
		Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
		Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
		cParte4+" "+cParte5

		CB := cBarra
		RN := cDigital
		NN := cNroDoc
		//	Aadd(aRet,cBarra)
		//	Aadd(aRet,cDigital)
		//	Aadd(aRet,cNroDoc)

	EndIf

Return({CB,RN,NN})

Static Function ArrumaAno(_dDataValida)

	local _cDataAno := year(_dDataValida)
	local _cDataDia := Day(_dDataValida)
	local _cDataMes := Month(_dDataValida)
	if len(CVALTOCHAR(_cDataMes)) == 1
		_cDataMes := "0"+CVALTOCHAR(_cDataMes)
	else
		_cDataMes := CVALTOCHAR(_cDataMes)
	endif

	if len(CVALTOCHAR(_cDataDia)) == 1
		_cDataDia := "0"+CVALTOCHAR(_cDataDia)
	else
		_cDataDia := CVALTOCHAR(_cDataDia)
	endif

	if len(CVALTOCHAR(_cDataAno)) == 2
		_cDataAno := "20"+CVALTOCHAR(_cDataAno)
	else
		_cDataAno := CVALTOCHAR(_cDataAno)
	endif
	_dDataValida := _cDataDia+"/"+_cDataMes+"/"+_cDataAno

return _dDataValida


Static Function SelBcoDia()
	Local aDados := {}

	cBcoDia := SA1->A1_ZZBOL 
	aDados := Array(3)
	aFill(aDados,Space(3))

	If SA1->A1_ZZBOL == "P"

		lTem := .F.
		DbSelectArea("SEE")
		DbGotop()

		While SEE->(!Eof())

			If SEE->EE_ZZBCDIA == "P"
				lTem := .T.
				Exit
			EndIf

			DbSkip()

		End

		If !lTem
			cBcoDia := "S"
		Else 
			cBcoPref := SA1->A1_BCO 
		EndIf

		DbSelectArea("SEE")
		DbGotop()

		While SEE->(!Eof())

			If SEE->EE_BANCO == cBcoPref   
				aDados[1] := SEE->EE_CODIGO
				aDados[2] := SEE->EE_AGENCIA
				aDados[3] := SEE->EE_CONTA
				Exit
			EndIf

			DbSkip()

		End

	Else 

		DbSelectArea("SEE")
		DbGotop()

		While SEE->(!Eof())

			If SEE->EE_ZZBCDIA == cBcoDia 
				aDados[1] := SEE->EE_CODIGO
				aDados[2] := SEE->EE_AGENCIA
				aDados[3] := SEE->EE_CONTA
				Exit
			EndIf


			DbSkip()

		End

	EndIf


Return aDados


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Numitau   ºAutor  ³Microsiga           º Data ³  09/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o numero sequencial para o Banco Itau                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumItau()
	Local cNum
	Local cNosso

	cNum := StrZero(Val(Substr(SEE->EE_FAXATU,1,8))+1,8)

	cNosso := AllTrim(SEE->EE_AGENCIA)+Alltrim(SEE->EE_CONTA)+SEE->EE_ZZCARTE+cNum

	cDig := Str(Modulo10( cNosso ),1)

	cNum += cDig

	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	SEE->EE_FAXATU := Substr(cNum,1,8)
	MsUnlock()

Return cNum


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Numitau   ºAutor  ³Microsiga           º Data ³  09/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera o numero sequencial para o Banco Itau                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumSafra()
	Local cNum
	Local cNosso

	cNum := StrZero(Val(Substr(SEE->EE_FAXATU,1,8))+1,8)

	cDig := Str(Modulo11( cNum ),1)

	cNum += cDig

	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	SEE->EE_FAXATU := Substr(cNum,1,8)
	MsUnlock()

Return cNum


/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_DB   ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CALC_DB(cVariavel)
	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	base   := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		If base >= 10
			base := 2
		EndIf
		auxi   := Val(SubStr(cBase, idig, 1)) * base
		sumdig := SumDig+auxi
		base   := base + 1
		iDig   := iDig-1
	EndDo
	auxi := mod(sumdig,11)
	If auxi == 0 .or. auxi == 1 .or. auxi >= 10
		auxi := 1
	Else
		auxi := 11 - auxi
	EndIf

Return(str(auxi,1,0))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGITO    ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DIGITO(cVariavel)

	Local Auxi := 0, sumdig := 0

	cbase  := cVariavel
	lbase  := LEN(cBase)
	umdois := 2
	sumdig := 0
	Auxi   := 0
	iDig   := lBase
	While iDig >= 1
		auxi   := Val(SubStr(cBase, idig, 1)) * umdois
		sumdig := SumDig+If (auxi < 10, auxi, (auxi-9))
		umdois := 3 - umdois
		iDig:=iDig-1
	EndDo
	cResultDiv := sumdig / 10
	cRestoDiv  := sumdig - (INT(cResultDiv)*10)

	if cRestoDiv = 0
		auxi := 0
	else
		auxi := 10 - cRestoDiv
	EndIf

Return(str(auxi,1,0))

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  07/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Agencia(_cBanco,_nAgencia)
	Local _cRet := ""
	If _cBanco $ "479/389"
		_cRet := AllTrim(SEE->EE_AGBOSTO)
		ñElseIF _cBanco == "341" .or. _cBanco == "422" .Or. _cBanco == "033"
		_cRet := StrZero(Val(AllTrim(_nAgencia)),4)
	Else
		_cRet := SubStr(StrZero(Val(AllTrim(_nAgencia)),5),1,4)+"-"+SubStr(StrZero(Val(AllTrim(_nAgencia)),5),5,1)
	Endif
Return(_cRet)

Static Function Conta(_cBanco,_cConta)
	Local _cRet := ""
	If _cBanco $ "479/389"
		_cRet := AllTrim(SEE->EE_CODEMP)
	ElseIf _cBanco == "341"
		_cRet := StrZero(Val(SubStr(AllTrim(_cConta),1,Len(AllTrim(_cConta))-1)),5)
	Else
		_cRet := StrTran(_cConta,"-","")
		_cRet := SubStr(AllTrim(_cRet),1,Len(AllTrim(_cRet))-1)
	Endif
Return(_cRet)

//Ret_cBarra1(aDadosBanco[1] , Alltrim(cNroDoc) , (SE1->E1_SALDO-nVlrAbat) , aDadosBanco[6] , "9" , cBcoCon )
Static Function Ret_Bar033(cBanco,cNosso,nValor,cCart,cMoeda,cBcoCon)

	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra		:= ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local aRet			:= {}

	// campo livre
	// cCampoL := "0"+cBcoCon+cNosso+cCart+"00"   // FEITO PELO MARCOS

	cCampoL := "9"+cBcoCon+cNosso+"0"+cCart
	// ALERT(cCampoL)

	//Fator de Vencimento + Valor do titulo
	nFator := SE1->E1_VENCREA - CtoD("07/10/1997")
	cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

	cLivre := cBanco+cMoeda+cFatorValor+cCampoL

	// campo do codigo de barra
	cDigBarra := CALC_DB( cLivre )
	cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

	// composicao da linha digitavel
	cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
	cDig1    := DIGITO( cParte1 )
	cParte2  := Substr(cBarra,25,10)
	cDig2    := DIGITO( cParte2 )
	cParte3  := Substr(cBarra,35,10)
	cDig3    := DIGITO( cParte3 )
	cParte4  := cDigBarra
	cParte5  := cFatorValor

	cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
	Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
	Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
	cParte4+" "+cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ret_Bar001ºAutor  ³Carlos R. Moreira   º Data ³  02/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Codigo de Barras do Banco do Brasil                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ret_Bar001(cBanco,cNosso,nValor,cCart,cMoeda,cBcoCon)

	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra		:= ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local aRet			:= {}

	// campo livre
	cCampoL := Replicate("0",6)+cBcoCon+cNosso+Alltrim(cCart)

	//Fator de Vencimento + Valor do titulo
	nFator := SE1->E1_VENCREA - CtoD("07/10/1997")
	cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

	cLivre := cBanco+cMoeda+cFatorValor+cCampoL

	// campo do codigo de barra
	cDigBarra := CALC_DB( cLivre )
	cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

	// composicao da linha digitavel
	cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
	cDig1    := DIGITO( cParte1 )
	cParte2  := Substr(cBarra,25,10)
	cDig2    := DIGITO( cParte2 )
	cParte3  := Substr(cBarra,35,10)
	cDig3    := DIGITO( cParte3 )
	cParte4  := cDigBarra
	cParte5  := cFatorValor

	cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
	Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
	Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
	cParte4+" "+cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ret_Bar001ºAutor  ³Carlos R. Moreira   º Data ³  02/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Codigo de Barras do Banco do Brasil                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Gtex                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ret_Bar422(cBanco,cNosso,nValor,cCart,cMoeda,cBcoCon,cTpCob)

	Local cCampoL		:= ""
	Local cFatorValor	:= ""
	Local cLivre		:= ""
	Local cDigBarra		:= ""
	Local cBarra		:= ""
	Local cParte1		:= ""
	Local cDig1			:= ""
	Local cParte2		:= ""
	Local cDig2			:= ""
	Local cParte3		:= ""
	Local cDig3			:= ""
	Local cParte4		:= ""
	Local cParte5		:= ""
	Local cDigital		:= ""
	Local aRet			:= {}

	// campo livre
	cCampoL := "7"+cBcoCon+cNosso+Alltrim(cTpCob)

	//Fator de Vencimento + Valor do titulo
	nFator := SE1->E1_VENCREA - CtoD("07/10/1997")
	cFatorValor  := Alltrim(Str(nFator))+StrZero(nValor*100,10)

	cLivre := cBanco+cMoeda+cFatorValor+cCampoL

	// campo do codigo de barra
	cDigBarra := CALC_DB( cLivre )
	cBarra    := Substr(cLivre,1,4)+cDigBarra+Substr(cLivre,5)

	// composicao da linha digitavel
	cParte1  := Substr(cBarra,1,4)+SUBSTR(cBarra,20,5)
	cDig1    := DIGITO( cParte1 )
	cParte2  := Substr(cBarra,25,10)
	cDig2    := DIGITO( cParte2 )
	cParte3  := Substr(cBarra,35,10)
	cDig3    := DIGITO( cParte3 )
	cParte4  := cDigBarra
	cParte5  := cFatorValor

	cDigital := Transform(cParte1+cDig1,"@R 99999.99999")+" "+;
	Transform(cParte2+cDig2,"@R 99999.999999")+" "+;
	Transform(cParte3+cDig3,"@R 99999.999999")+" "+;
	cParte4+" "+cParte5

	Aadd(aRet,cBarra)
	Aadd(aRet,cDigital)
	Aadd(aRet,cNosso)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EnviaEmailºAutor  ³Carlos R Moreira    º Data ³  10/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EnviaEmail(cArquivo)
	Local aEmail := {}
	Local aArqAux := {}
	Local aAttach := {}
	Local cBody   := ""
	Local cAttach := ""
	Local nX      := 0
	Local nY      := 0

	aDadosEmail := DadosEmail()

	aArqAux := Directory(cArquivo+"*.jpg")

	For nY:=1 to Len(aArqAux)
		//AADD(aAttach,{aArqAux[nY,1],aRel[nX,3]}) 
		If !Empty(cAttach)
			cAttach +=";"
		EndIf
		cAttach +=cStartPath+aArqAux[nY,1]
	Next nY

	//AADD(aEmail,Alltrim(SA4->A4_EMAIL))
	//AADD(aEmail,UsrRetMail(RetCodUsr()))

	oWF:= TWFProcess():New('BOLETO','Pedido de compra')
	oWF:cPriority := "3"
	//For nX:= 1 to Len(aEmail)
	oWF:NewTask('Boleto','\workflow\html\boleto.htm')
	oWF:cTo := aDadosEmail[1]
	oWF:AttachFile(cAttach)
	oWF:cSubject := "Boleto "+Substr(cArquivo,3)
	oWF:oHtml:ValByName("cMensagem" , aDadosEmail[2] )
	//oWF:oHtml:ValByName("cEmissao" , Dtoc(QRYFAT->F2_EMISSAO) )
	oWF:Start()
	oWF:Finish()
	//Next

Return()


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
Static  Function DadosEmail()

	Local cEmail := Space(120)
	Local cCorpo := " "
	Local lLista := .T.
	Local lCancel:= .T.
	Local oEmail
	Local oCorpo
	Local oDlg

	cEmail := Alltrim(SA1->A1_EMAIL)+Space(120-Len(Alltrim(SA1->A1_EMAIL)) )

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Nossonum ³ Autor ³                       ³ Data ³ 25/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera a fun‡Æo NossoNum() + o digito de controle. Este c¢di-³±±
±±³          ³ go gerado, ser  gravado no E1_NUMBCO e no arquivo TXT.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Nossonr(lBcoCorr)

	If Type("LBCOCORR") == "U"
		lBcoCorr := .F.
	EndIf 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fun‡Æo para gerar NossoNum()                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(SE1->E1_NUMBCO) 

		dbSelectArea("SEE")
		RecLock("SEE",.f.)

		If !lBcoCorr
			SEE->EE_FAXATU := Strzero( ( Val( SEE->EE_FAXATU ) +1 ), 11 )
		Else                                                            
			SEE->EE_NOSSNUM := Strzero( ( Val( SEE->EE_NOSSNUM ) +1 ), 11 )
		EndIf

		MsUnlock()

		dbSelectArea("SE1")

		_cFaixa := If(lBcocorr,SEE->EE_NOSSNUM,SEE->EE_FAXATU)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fun‡Æo para gerar Digito de Controle                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


		nResult := 0
		nSoma   := 0
		cDc     := ""
		i       := 0
		//nTam    := Len( SEE->EE_FKCART ) + Len( Alltrim( SE1->E1_NUMBCO ) )
		nTam    := Len( Alltrim( _cFaixa ) ) + 2

		If lBcoCorr
			cCart :=  StrZero(Val(SEE->EE_CARTCOR),2)
		Else     
			cCart := StrZero(Val(SEE->EE_ZZCARTE),2)
		EndIf 
		cCrtBco := ( cCart  + AllTrim( _cFaixa ) )
		nDc     := 0
		nMulti  := 2    
		nTam    := Len(Alltrim(cCrtBco))

		For i  := Len(Alltrim(cCrtBco)) To 1 Step -1
			nSoma   := Val(Substr(cCrtBco,nTam,1))*nMulti
			nResult := nResult + nSoma
			nTam    := nTam - 1

			If ( NMULTI < 7 )
				NMULTI := NMULTI + 1
			Else
				NMULTI := 2
			Endif

		Next i

		nDC  := Mod(nResult,11)

		Do Case
			Case ( nDc = 1 )

			cDig := "P"
			Case ( nDc = 0 )

			cDig := "0"
			otherwise

			cDig := Str( ( 11 - nDc ), 01 )
		EndCase

		Nossonum := Alltrim(_cFaixa) + Alltrim(cDig)

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO := Nossonum
		MsUnlock()

	EndIf

Return(SE1->E1_NUMBCO)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Microsiga           º Data ³  06/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o nosso numero para o Banco Santander              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumSantand()
	Local cNroDoc := Replicate("0",13)

	//cNumSeq	:= strzero(VAL(SE1->E1_PREFIXO),3)
	cNumSeq	:= StrZero(Val(Substr(SE1->E1_NUM,4,6)+StrZero(Val(SE1->E1_PARCELA),2)),12) // StrZero(Val(SE1->E1_NUM),12)

	If !Empty(SE1->E1_NUMBCO)
		cNroDoc  := Right(Alltrim(SE1->E1_NUMBCO),8) //Substr(SE1->E1_NUMBCO,4,7)+
	Else                                 
		cNroDoc  := cNumSeq
		cDig     := Modulo11(cNroDoc)
		cNroDoc  += cDig
	Endif    

	If Empty(SE1->E1_NUMBCO) 
		cNroDoc := cNumSeq
		cDig    := Modulo11(cNroDoc) //STRZERO(VAL(NOSSONUM()),12)
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO := cNroDoc+Modulo11(cNroDoc)
		SE1->(MsUnlock())
		cNroDoc += cDig //SE1->E1_NUMBCO

		cNroDoc  := Right(Alltrim(SE1->E1_NUMBCO),8)

	Endif

Return cNroDoc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NumBcoBrasºAutor  ³Microsiga           º Data ³  06/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o nosso numero para o Banco do Brasil              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function NumBcoBrasil()
Local cNroDoc := Replicate("0",10)

cNumSeq	:= StrZero(Val(SE1->E1_NUM),7)+StrZero(Val(SE1->E1_PARCELA),3) 

If !Empty(SE1->E1_NUMBCO)
   cNroDoc  := Substr(Alltrim(SE1->E1_NUMBCO),1,10) 
Else                                 

   cNroDoc  := cNumSeq
//   cDig     := Modulo11(cNroDoc)
//   cNroDoc  += cDig
Endif    

If Empty(SE1->E1_NUMBCO) 
	cNroDoc := cNumSeq
//	cDig    := Modulo11(cNroDoc) //STRZERO(VAL(NOSSONUM()),12)
	RecLock("SE1",.F.)
	SE1->E1_NUMBCO := cNroDoc //+Modulo11(cNroDoc)
	SE1->(MsUnlock())
//	cNroDoc //+= cDig //SE1->E1_NUMBCO
Endif

Return cNroDoc