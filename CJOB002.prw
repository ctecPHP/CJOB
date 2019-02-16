//-------------------------------------------------------------------
/*/{Protheus.doc} CJOB002
Consulta SQL em outro banco
@author  Ademilson Nnes
@since   16-02-2019
@version version 12.1.7
/*/
//-------------------------------------------------------------------
User Function CJOB002()
    Local cEmp    := '99'
    Local cFilial := '01'
    Local cUser   := 'Administrador'
    Local cPsw    := ' '
    Local aTables := {'SA1','SB1'}
    Local cAmb    := 'FAT'
    Local aArea   := GetArea()

    RpcSetType(3)
    RpcSetEnv( cEmp, cFilial, cUser, cPsw, cAmb, '', aTables, , , ,  )
    //RpcSetEnv( "99","01", "Administrador", " ", "FAT", "", aTables, , , ,  )

    BeginSQL Alias 'sobel'
        SELECT A1_NOME
        FROM %table:SA1% SA1
    EndSQL

    While! sobel->(EoF())
        MsgAlert(sobel->A1_NOME)
        sobel->(DbSkip())
    End

    sobel->(DbCloseArea())
    RestArea(aArea)

Return