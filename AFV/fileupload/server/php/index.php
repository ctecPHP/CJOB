<?php
    session_start();
/*
 * @Autor Ademilson Nunes
 * 
 * 
 * 
 */

error_reporting(E_ALL | E_STRICT);
require('UploadHandler.php');

$path = $_POST['path'];

$options = array('upload_dir'=>'./files/' . $path , 'upload_url'=>'./files/' . $path );

$upload_handler = new UploadHandler($options);
