<?php
//Connection
require_once('../include/template/dsn.php');
$tsql_callSP = "spRelatores_Imprimir";
$stmt = sqlsrv_query( $conn, $tsql_callSP);

$databneficiarios = "{\"data\":[";
$contreg = 0;

while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{  
	  /*$PRY_Carpeta = $row['PRY_Carpeta'];
	  $LFO_Id = $row['LFO_Id'];*/
      $contreg = $contreg + 1;
      $databneficiarios = $databneficiarios . $row['tbl_relatores'] . ',';
}
sqlsrv_free_stmt( $stmt);
sqlsrv_close( $conn);

$databneficiarios=$databneficiarios . "]" . ",\"recordsTotal\": \"" . $contreg . "\"" . "}";
echo str_replace("],]","]]",$databneficiarios);
?>