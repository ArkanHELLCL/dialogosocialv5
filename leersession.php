<?php
$url_actual = "https://" . $_SERVER["SERVER_NAME"]; //. $_SERVER["REQUEST_URI"];
$file = $url_actual."/sessionConnector.asp";
function GetASPSessionState($file){
    if(stripos($_SERVER["HTTP_COOKIE"], "ASPSESSIONID") === false){
        # since ASP sessions stored in memory 
        # don't make request to get ASP session state if the cookie does not contain ASPSESSIONID
        # otherwise IIS will create new redundant sessions for each of your checks so it wouldn't be a memory-friendly way
        # returning an empty array
        return array();
    } else {
        $options = array(
			'http' => array(
				'method'=>"GET", 
				'header' => "Cookie: " . $_SERVER["HTTP_COOKIE"]
			),
			"ssl"=>array(
				"verify_peer"=>false,
				"verify_peer_name"=>false,
			),
        );
        $cx = stream_context_create($options);
        $response = file_get_contents($file, false, $cx);		
        return json_decode($response, JSON_FORCE_OBJECT);
    }
}

$aspSessionState = GetASPSessionState($file);
print_r( $aspSessionState);
//echo $aspSessionState["ds5_usrid"];
$str_conn=explode(";",$aspSessionState["DSN_DialogoSocialv5"]);
//print_r($str_conn);

$DataBase = explode("=",$str_conn[2]);	//DATABASE
$Server = explode("=",$str_conn[3]); //Server
echo $DataBase[1];	//DATABASE
echo $Server[1];	//Server

?>