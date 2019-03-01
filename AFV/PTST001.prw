/*/{Protheus.doc} PTST001
    (long_description) PTST001
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function PTST001()
    Local aNum := { '1','2','3' }

    for i = 1 to len( aNum ) 
        MsgAlert( cValToChar(aNum[i]) )
    next 

Return 