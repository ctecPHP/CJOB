#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA410COR  บAutor  ณMicrosiga           บ Data ณ  14/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para manipular as cores do Browse de PV    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MA410COR()

	aCores := { { " C5_STAPED = 'L' "  , 'ENABLE' },;
	{ " C5_STAPED = 'F'  " , 'DISABLE'  },;
	{ " C5_STAPED = 'C'" , 'BR_PINK'  },;
	{ " C5_STAPED = 'T'" , 'BR_LARANJA'  },;
	{ " C5_STAPED = 'P'" , 'BR_BRANCO'  },;
	{ " C5_STAPED = 'S'" , 'BR_MARRON_OCEAN'  },;
	{ " C5_STAPED = 'R'" , 'BR_VIOLETA'  },;	
	{ " C5_STAPED = 'D'" , 'BR_AMARELO'  },;
	{ " C5_STAPED = 'O'" , 'BR_AZUL_CLARO'  },;
	{ " C5_STAPED = 'A'" , 'BR_VERDE_ESCURO' } ,; 		
	{ " C5_STAPED = 'M'" , 'BR_CINZA'  }}

//	{ " C5_STAPED = 'E'" , 'BR_AZUL'  },;
Return aCores
