<?php 
  
   define('DB_HOST'        , "192.168.0.4");
   define('DB_USER'        , "sa");
   define('DB_PASSWORD'    , "S0b3l2036");
   define('DB_NAME'        , "Protheus_Teste12");
   define('DB_DRIVER'      , "sqlsrv");
  
   require_once "Class/Conexao.php";
  
   try
   {
  
       $Conexao    = Conexao::getConnection();
       $query      = $Conexao->query("SELECT A1_COD, A1_NOME FROM SA1010");
       $clientes   = $query->fetchAll();
  
   }
   catch(Exception $e)
   {
       echo $e->getMessage();
       exit;
   }
  
?>
<table border='1'>
   <tr>
       <td>C�digo</td>
       <td>Nome</td>
   </tr>
   <?php
       foreach($clientes as $cliente) 
       {
   ?>
       <tr>
           <td><?php echo $cliente['A1_COD']; ?></td>
           <td><?php echo $cliente['A1_NOME']; ?></td>         
       </tr>
   <?php
       }
   ?>
</table>