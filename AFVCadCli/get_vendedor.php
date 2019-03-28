<?php

	$afvUser = $_POST['afvUser'];		
	//$afvUser = 'rp212.04';		
		
	define('DB_HOST'        , "192.168.0.4");
    define('DB_USER'        , "sa");
    define('DB_PASSWORD'    , "S0b3l2036");
    define('DB_NAME'        , "AFVServer_SOBEL");
    define('DB_DRIVER'      , "sqlsrv");
   
require_once "Class/Conexao.php";
		
	try
	{
		
		$Conexao    = Conexao::getConnection();

		$sql  = "SELECT V.NOME AS NOME,";
		$sql .= "LEFT(V.CODIGOVENDEDORESP, 6) AS CODVEND, ";
		$sql .= "RIGHT(V.CODIGOVENDEDORESP, 2) AS UNIDFAT ";
		$sql .= 'FROM T$_USUARIO U  ';
		$sql .= "INNER JOIN T_VENDEDOR V ON V.CODIGOVENDEDOR = U.CODIGOEMPRESA ";
		$sql .= "WHERE U.USUARIO = '" . $afvUser . "'";

		$query = $Conexao->query($sql);
		$vendedor = $query->fetchAll();
		
	}
	catch(Exception $e)
	{
		echo $e->getMessage();
		exit;
	}

	if ($vendedor <> null) 
	{
		$result['nome']    = $vendedor[0]['NOME'];
		$result['codvend'] = $vendedor[0]['CODVEND'];
		$result['unidfat'] = $vendedor[0]['UNIDFAT'];

		echo json_encode($result, JSON_UNESCAPED_UNICODE);
	}
	else
	{
		echo json_encode(null, JSON_UNESCAPED_UNICODE);
	}

	
	  
?>