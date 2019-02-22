User function Exemp992()
	Local cArqTrb, cIndice1, cIndice2, cIndice3
	Local i
	Private oBrowse
	Private aRotina		:= MenuDef()
	Private cCadastro 	:= "TITULO DA JANELA"
	Private aCampos	:= {}, aSeek := {}, aDados := {}, aValores := {}, aFieFilter := {}
	
	//Array contendo os campos da tabela temporária
	AAdd(aCampos,{"TR_ST"  	, "C" , 01 , 0})
	AAdd(aCampos,{"TR_ID" 	, "C" , 06 , 0})
	AAdd(aCampos,{"TR_NOME" , "C" , 50 , 0})
	AAdd(aCampos,{"TR_LOGIN", "C" , 20 , 0})
	AAdd(aCampos,{"TR_LOGIN", "C" , 20 , 0})
	AAdd(aCampos,{"TR_EMAIL", "C" ,150 , 0})
	AAdd(aCampos,{"TR_CARGO", "C" , 50 , 0})
	AAdd(aCampos,{"TR_DEPTO", "C" , 50 , 0})
	AAdd(aCampos,{"TR_SUPER", "C" ,  6 , 0})
	AAdd(aCampos,{"TR_POS"  , "N" , 12 , 0})	
	
	//Antes de criar a tabela, verificar se a mesma já foi aberta
	If (Select("TRB") <> 0)
		dbSelectArea("TRB")
		TRB->(dbCloseArea ())
	Endif
	
	//Criar tabela temporária
	cArqTrb   := CriaTrab(aCampos,.T.)
	
	//Definir indices da tabela
	cIndice1 := Alltrim(CriaTrab(,.F.))
	cIndice2 := cIndice1
	cIndice3 := cIndice1

	cIndice1 := Left(cIndice1,5)+Right(cIndice1,2)+"A"
	cIndice2 := Left(cIndice2,5)+Right(cIndice2,2)+"B"
	cIndice3 := Left(cIndice3,5)+Right(cIndice3,2)+"C"

	If File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	EndIf

	If File(cIndice2+OrdBagExt())
		FErase(cIndice2+OrdBagExt())
	EndIf

	If File(cIndice3+OrdBagExt())
		FErase(cIndice3+OrdBagExt())
	EndIf
	
	//Criar e abrir a tabela
	dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)
	
	/*Criar indice*/
	IndRegua("TRB", cIndice1, "TR_ID"	,,, "Indice ID...")
	IndRegua("TRB", cIndice2, "TR_LOGIN",,, "Indice Login...")
	IndRegua("TRB", cIndice3, "TR_NOME"	,,, "Indice Nome...")
	dbClearIndex()
	dbSetIndex(cIndice1+OrdBagExt())
	dbSetIndex(cIndice2+OrdBagExt())
	dbSetIndex(cIndice3+OrdBagExt())
	
	/*popular a tabela*/
	aadd(aValores,{"A","000001","ADMINISTRADOR DO SISTEMA","ADMIN","ADMINISTRADOR","INFORMÁTICA","admin@admin.com","000001"})
	aadd(aValores,{"C","000002","USUARIO CONTABILIDADE","USUARIO1","CONTADOR","CONTABILIDADE","user1@user.com","000001"})
	aadd(aValores,{"R","000004","USUARIO RECURSOS HUMANOS","USUARIO2","ANALISTA","RECURSOS HUMANOS","user2@user.com",""})
	
	For i:= 1 to len(aValores)
		If RecLock("TRB",.t.)
			TRB->TR_ST    := aValores[i,1]
			TRB->TR_ID 	  := aValores[i,2]
			TRB->TR_NOME  := aValores[i,3]
			TRB->TR_LOGIN := aValores[i,4]
			TRB->TR_CARGO := aValores[i,5]
			TRB->TR_DEPTO := aValores[i,6]
			TRB->TR_EMAIL := aValores[i,7]
			TRB->TR_SUPER := aValores[i,8]
			TRB->TR_POS   := i
			MsUnLock()
		Endif
	Next
	dbSelectArea("TRB")
	TRB->(DbGoTop())

	//Campos que irão compor o combo de pesquisa na tela principal
	Aadd(aSeek,{"ID"   , {{"","C",06,0, "TR_ID"   ,"@!"}}, 1, .T. } )
	Aadd(aSeek,{"Login", {{"","C",20,0, "TR_LOGIN","@!"}}, 2, .T. } )
	Aadd(aSeek,{"Nome" , {{"","C",50,0, "TR_NOME" ,"@!"}}, 3, .T. } )
	
	//Campos que irão compor a tela de filtro
	Aadd(aFieFilter,{"TR_ID"	, "ID"   , "C", 06, 0,"@!"})
	Aadd(aFieFilter,{"TR_LOGIN"	, "Login", "C", 20, 0,"@!"})
	Aadd(aFieFilter,{"TR_NOME"	, "Nome" , "C", 50, 0,"@!"})
	
	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias( "TRB" )
	oBrowse:SetDescription( cCadastro )
	oBrowse:SetSeek(.T.,aSeek)
	oBrowse:SetTemporary(.T.)
	oBrowse:SetLocate()
	oBrowse:SetUseFilter(.T.)
	oBrowse:SetDBFFilter(.T.)
	oBrowse:SetFilterDefault( "" ) //Exemplo de como inserir um filtro padrão >>> "TR_ST == 'A'"
	oBrowse:SetFieldFilter(aFieFilter)
	oBrowse:DisableDetails()
	
	//Legenda da grade, é obrigatório carregar antes de montar as colunas
	oBrowse:AddLegend("TR_ST=='A'","GREEN" 	,"Grupo Administradores")
	oBrowse:AddLegend("TR_ST=='C'","BLUE"  	,"Grupo Contábil")
	oBrowse:AddLegend("TR_ST=='R'","RED"  	,"Grupo RH")
	
	//Detalhes das colunas que serão exibidas
	oBrowse:SetColumns(MontaColunas("TR_ID"		,"ID"		,01,"@!",0,010,0))
	oBrowse:SetColumns(MontaColunas("TR_NOME"	,"Nome"		,02,"@!",1,080,0))
	oBrowse:SetColumns(MontaColunas("TR_LOGIN"	,"Login"	,03,"@!",1,040,0))
	oBrowse:SetColumns(MontaColunas("TR_CARGO"	,"Cargo"	,04,"@!",1,050,0))
	oBrowse:SetColumns(MontaColunas("TR_DEPTO"	,"Depto"	,05,"@!",1,100,0))
	oBrowse:SetColumns(MontaColunas("TR_EMAIL"	,"E-mail"	,06,"",1,100,0))
	oBrowse:SetColumns(MontaColunas("TR_SUPER"	,"Superior"	,07,"@!",1,020,0))
	oBrowse:SetColumns(MontaColunas("TR_POS"	,"RECNO"	,08,"@E9999999",2,20,0))	
	oBrowse:Activate()
	If !Empty(cArqTrb)
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		cArqTrb := ""
		TRB->(DbCloseArea())
		delTabTmp('TRB')
    	dbClearAll()
	Endif
    	
return(Nil)

Static Function MontaColunas(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn   := {}
	bData 	:= ''
	Default nAlign 	:= 1
	Default nSize 	:= 20
	Default nDecimal:= 0
	Default nArrData:= 0
	
	
	
	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf
	
	/* Array da coluna
	[n][01] Título da coluna
	[n][02] Code-Block de carga dos dados
	[n][03] Tipo de dados
	[n][04] Máscara
	[n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
	[n][06] Tamanho
	[n][07] Decimal
	[n][08] Indica se permite a edição
	[n][09] Code-Block de validação da coluna após a edição
	[n][10] Indica se exibe imagem
	[n][11] Code-Block de execução do duplo clique
	[n][12] Variável a ser utilizada na edição (ReadVar)
	[n][13] Code-Block de execução do clique no header
	[n][14] Indica se a coluna está deletada
	[n][15] Indica se a coluna será exibida nos detalhes do Browse
	[n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
	*/
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}

Static Function MenuDef()
	Local aArea		:= GetArea()
	Local aRotina 	:= {}
	Local aRotina1 := {}
	
	AADD(aRotina1, {"Consulta Produto"	, "MATC050()"		, 0, 6, 0, Nil })
	AADD(aRotina1, {"Legenda"			, "U_EXEM992L"		, 0,11, 0, Nil })
	
	AADD(aRotina, {"Pesquisar"			, "PesqBrw"			, 0, 1, 0, .T. })
	AADD(aRotina, {"Visualizar"			, "U_EXEM992I"		, 0, 2, 0, .F. })
	
	AADD(aRotina, {"Incluir"			, "U_EXEM992I"		, 0, 3, 0, Nil })
	AADD(aRotina, {"Alterar"			, "U_EXEM992I"		, 0, 4, 0, Nil })
	AADD(aRotina, {"Excluir"			, "U_EXEM992I"		, 0, 5, 3, Nil })
	
	AADD(aRotina, {"Mais ações..."    	, aRotina1          , 0, 4, 0, Nil })
	
Return( aRotina )