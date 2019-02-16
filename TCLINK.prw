#INCLUDE "TOTVS.CH"
 
 
User Function TCLink()
Local nRet		:= 0
Local cMsg		:= ''
 
 
If ( nRet := TCLink( 'MSSQL/P12', '127.0.0.1', 7890 ) ) < 0
cMsg += 'Conexão (MSSQL/P12): Erro ' + Str( nRet, 4 )
Else
TcUnlink( nRet )
Endif
 
If ( nRet := TCLink( 'MSSQL/P12', '127.0.0.1', 7890 ) ) < 0
cMsg += 'Conexão (MSSQL/P12): Erro ' + Str( nRet, 4 )
Else
TcUnlink( nRet )
Endif
 
 
MsgInfo( cMsg, 'SOBEL' )
 
 
Return( Nil )