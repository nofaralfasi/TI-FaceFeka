<?php
//    define('DB_SERVER', 'localhost:3036');
//    define('DB_USERNAME', 'root');
//    define('DB_PASSWORD', '20b666');
//    define('DB_DATABASE', 'facefeka');
//    $db = mysqli_connect(DB_SERVER,DB_USERNAME,DB_PASSWORD,DB_DATABASE);
 
   $user = 'root';
   $pass = '';
//    $pass = '20b666';
   $db = 'facefeka';

   $db = new mysqli('localhost', $user, $pass, $db) or die("ERROR");

   echo $db;
?>