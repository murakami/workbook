<?php
    function connectToDB()
    {
        $userName = "demo";
        $password = "test";
        $server = "localhost";
        $db = mysql_connect($server, $userName, $passwork);
        if ($db != false) {
            mysql_selectdb("PushNotification");
            mysql_set_charset('utf-8');
        }
        return $db;
    }
?>