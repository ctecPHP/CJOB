#include 'totvs.ch'
/*/{Protheus.doc} APTST
    @type  Function
    @author user
    /*/
 User Function APTST()
    Local oObj := APHello():New('Olá mundo advpl')
        oObj:SayHello()
Return 


//-------------------------------------------------------------------
/*/{Protheus.doc} APHello
@author  author
@since   date
/*/
//-------------------------------------------------------------------
Class APHello
    Data cMsg as String

    Method New(cMsg) Constructor
    Method SayHello() 

EndClass

Method new(cMsg) Class APHello
        self:cMsg := cMsg
Return self

Method SayHello() Class APHello
        MsgInfo(self:cMsg)
Return .T.


    
