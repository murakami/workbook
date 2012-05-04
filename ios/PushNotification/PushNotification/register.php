<?php
    
    require_once "/Library/WebServer/PushNotificationDB.php";
    
    $token = null;
    if (!isset($_POST['token'])) {
        print "-1";
        exit;
    }
    
    $token = $_POST['token'];
    $result = -1;
    
    $db = connectToDB();
    if ($db) {
        $query = "SELECT token FROM device WHERE token='$token'";
        $resource = mysql_query($query);
        if ($resource) {
            if (!mysql_fetch_row($resource)) {
                $query = "INSERT INTO device (token) VALUES ('$token')";
                if (mysql_query($query)) {
                    $result = 0;
                }
            }
            else {
                $result = 0;
            }
        }
        
        mysql_close($db);
    }
    
    print $result;
    
?>