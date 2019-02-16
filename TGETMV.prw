//=================================================================================================================================
//                                                                                                                                 
//  ######   ####    #####  ######  ###    ###  ##   ##        #####  ##   ##  ##     ##   ####  ######  ##   #####   ##     ##  
//    ##    ##       ##       ##    ## #  # ##  ##   ##        ##     ##   ##  ####   ##  ##       ##    ##  ##   ##  ####   ##  
//    ##    ##  ###  #####    ##    ##  ##  ##  ##   ##        #####  ##   ##  ##  ## ##  ##       ##    ##  ##   ##  ##  ## ##  
//    ##    ##   ##  ##       ##    ##      ##   ## ##         ##     ##   ##  ##    ###  ##       ##    ##  ##   ##  ##    ###  
//    ##     ####    #####    ##    ##      ##    ###          ##      #####   ##     ##   ####    ##    ##   #####   ##     ##  
//                                                                                                                                 
//=================================================================================================================================
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

    Local nDias := SuperGetMV( 'MV_DIAS', .T., '15', '01' )
    
    RpcSetType(3)	
	RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )

    MsgAlert( 'Result ' + nDias  )

Return 