<?php
    session_start();
/*
 * @Autor Ademilson Nunes
 * 
 * 
 * 
 */

error_reporting(E_ALL | E_STRICT);
require('../class/UploadHandler.php');


  if(isset($_POST['path']))
  {
      $_SESSION['path'] = $_REQUEST['path'];
  }    

$options = array('upload_dir'=>'../files/' . $_SESSION['path'] , 'upload_url'=>'../files/' . $_SESSION['path']);

$upload_handler = new UploadHandler($options);
