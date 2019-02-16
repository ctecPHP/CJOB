//==============================================================================================================
//                                                                                                              
//   ####   #####   #####   #####  ##             ####  ##   ##  #####   #####    #####  ###    ###    ###    
//  ##     ##   ##  ##  ##  ##     ##            ##     ##   ##  ##  ##  ##  ##   ##     ## #  # ##   ## ##   
//   ###   ##   ##  #####   #####  ##             ###   ##   ##  #####   #####    #####  ##  ##  ##  ##   ##  
//     ##  ##   ##  ##  ##  ##     ##               ##  ##   ##  ##      ##  ##   ##     ##      ##  #######  
//  ####    #####   #####   #####  ######        ####    #####   ##      ##   ##  #####  ##      ##  ##   ##  
//                                                                                                              
//==============================================================================================================

#include 'totvs.ch'
    /*/{Protheus.doc} TGETMV
    (long_description)
    @type  get 
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
 User Function TGETMV()
    Local cDbAFV     := 'MSSQL/P12'
    Local cSrvAFV    := '127.0.0.1'
    Local cPrtTopCnn := 7890
    Local aTables    := {'SA1','SB1'}
    
    RpcSetType(3)	
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )
    
    nHwnd := TCLink( cDbAFV, cSrvAFV, cPrtTopCnn )

    if nHwnd >= 0
        MsgAlert('Conectado')
    EndIf

    TCUnlink()
    RpcClearEnv()
Return 