/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FA060Qry บAutor  ณAntonio Guedes      บ Data ณ  23/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na para alterar filtro na query do browse บฑฑ
ฑฑบ          ณ de selecao do FINA060                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especificos                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿     
*/

User function FA060Qry()
Local cAgencia := PARAMIXB[1] 
Local cConta   := PARAMIXB[2] 
Local cRet     := ""  
Local cPerg := "F060BAN"
				
//PutSx1(cPerg,"01","Data Inicial               ?","","","mv_ch1","D",  8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",{{"Data Inicial de processamento "}},{{" "}},{{" "}},"")
//PutSx1(cPerg,"02","Data Final                 ?","","","mv_ch2","D",  8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",{{"Data Final de processamento   "}},{{" "}},{{" "}},"")
PutSx1(cPerg,"01","Filtra Portador/Banco      ?","","","mv_ch1","N",  1,0,0,"C","","","","","mv_par01","Bco.Bordero","","","","Bco.Bordero+Cart.","","","Todos","","","","","","","","",{{"Filtro de Portadores  "}},{{" "}},{{" "}},"")

Pergunte(cPerg,.T.)

    If mv_par01 == 1 
		cRet:= " E1_PORTADO='" + cPort060 + "' "
    Elseif mv_par01 == 2
		cRet:= " E1_PORTADO='" + cPort060 + "' OR E1_PORTADO='' "
    else
    	cRet:= " 1=1 "
    Endif	 


RETURN cRet 