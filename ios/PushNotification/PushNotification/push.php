<?php
    require_once "/Library/WebServer/PushNotificationDB.php";
    
    function pushNotification($apnsStream, $deviceToken, $payload)
    {
        $tokenBin = pack('H*', $deviceToken);
        $len = strlen($payload);
        if (256 < $len)
            return;
        $buf = chr(0) . chr(0) . chr(32) . $tokenBin . chr(($len >> 8) & 0xFF) . chr($len & 0xFF) . $payload;
        fwrite($apnsStream, $buf);
    }
    
    $msg = "";
    if (isset($_POST['msg']))
        $msg = $_POST['msg'];
    $sound = "default";
    if (isset($_POST['sound']))
        $sound = $_POST['sound'];
    $color = "FFFFFF";
    if (isset($_POST['color']))
        $color = $_POST['color'];
    
    $url = "ssl://gateway.sandbox.push.apple.com:2195";
    $certFile = "/Library/WebServer/aps_developer.pem";
    $context = stream_context_create();
    stream_context_set_option($context, 'ssl', 'local_cert', $certFile);
    $stream = stream_socket_client($url, $errno, $errstr, 60, STREAM_CLIENT_CONNECT, $context);
    if ($stream != FALSE) {
        $apsDict = array("alert" => $msg,
                         "sound" => $sound);
        $payloadDict = array("aps" => $apsDict,
                             "color" => $color);
        $payload = json_encode($payloadDict);
        $db = connectToDB();
        if ($db) {
            $query = "SELECT token FROM device";
            $resource = mysql_query($query);
            if ($resource) {
                while ($row = mysql_fetch_assoc($resource)) {
                    pushNotification($stream, $row['token'], $payload);
                }
            }
            mysql_close($db);
        }
        fclose($stream);
    }
    
    require_once "./push.html";
?>