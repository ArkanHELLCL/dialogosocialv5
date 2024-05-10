<?php
/*
 * jQuery File Upload Plugin PHP Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

error_reporting(E_ALL | E_STRICT);
require('UploadHandler.php');
//Connection
require_once('../../../../include/template/dsn.php');
$tsql_callSP = "spProyectoCarpeta_Consultar ?, ?";
$params = array(   
		  array($_GET['PRY_Id'], SQLSRV_PARAM_IN),
		  array($_GET['PRY_Identificador'], SQLSRV_PARAM_IN)
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$PRY_Carpeta='';
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{  
	  $PRY_Carpeta = $row['PRY_Carpeta'];
	  $LFO_Id = $row['LFO_Id'];
}
sqlsrv_free_stmt( $stmt);
//sqlsrv_close( $conn);
if($PRY_Carpeta==''){
	die('Carpeta no V�lida');
};
/*Rescatando nombre de carpeta del proyecto*/
$Hito='nodefinido';						

if($LFO_Id==10){

	if($_GET['PRY_Hito']<=0){
		$Hito='creacion';	
	}else{
		if($_GET['PRY_Hito']==1){
			$Hito='inicio';	
		}else{
			if($_GET['PRY_Hito']==2){
				$Hito='parcial';	
			}else{
				//if($_GET['PRY_Hito']==3){
				//	$Hito='desarrollo';	
				//}else{
					//if($_GET['PRY_Hito']==4){
					if($_GET['PRY_Hito']==3){
						$Hito='final';	
					}else{
						if($_GET['PRY_Hito']==99){
							$Hito='mediosgraficos';	
						}else{
							if($_GET['PRY_Hito']==98){
								$Hito='alumnodocumentos/'.$_GET['ALU_Rut'];	
							}else{
								$Hito='otros';
							}
						}
					}		
				//}		
			}	
		}
	}
}
if($LFO_Id==11){
	if($_GET['PRY_Hito']<=0){
		$Hito='creacion';	
	}else{
		if($_GET['PRY_Hito']==1){
			$Hito='inicial';	
		}else{
			if($_GET['PRY_Hito']==2){
				$Hito='consensos';	
			}else{
				if($_GET['PRY_Hito']==3){
					$Hito='sistematizacion';	
				}else{					
					if($_GET['PRY_Hito']==99){
						$Hito='mediosgraficos';	
					}else{						
						$Hito='otros';						
					}		
				}		
			}	
		}
	}
}
if($LFO_Id==12){

	if($_GET['PRY_Hito']<=0){
		$Hito='creacion';	
	}else{
		if($_GET['PRY_Hito']==1){
			$Hito='inicio';	
		}else{			
			if($_GET['PRY_Hito']==2){
				$Hito='final';	
			}else{
				if($_GET['PRY_Hito']==99){
					$Hito='mediosgraficos';	
				}else{
					if($_GET['PRY_Hito']==98){
						$Hito='alumnodocumentos/'.$_GET['ALU_Rut'];	
					}else{
						$Hito='otros';
					}
				}
			}
		}
	}
}
$upload_dir = 'd:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/'.$Hito.'/';
$options = array(
    'image_file_types' 	=> '/\.(gif|jpe?g|png|mp4|mp3)$/i',
    'upload_dir' 		=> $upload_dir,
    'upload_url' 		=> $upload_dir
);
class CustomUploadHandler extends UploadHandler {
	
    protected function initialize() {
    	parent::initialize();	 		
    }

    protected function handle_form_data($file, $index) {		
    }		
		
	protected function trim_file_name($file_path, $name, $size, $type, $error, $index, $content_range) {
		$this->options['Doc_Extension']=pathinfo($name , PATHINFO_EXTENSION);
		return $name;
    }

    protected function handle_file_upload($uploaded_file, $name, $size, $type, $error,
		$index = null, $content_range = null) {
		$file = parent::handle_file_upload(
			$uploaded_file, $name, $size, $type, $error, $index, $content_range
		);		        
        return $file;
    }

    protected function set_additional_file_properties($file) {
        parent::set_additional_file_properties($file);			
    }

    public function delete($print_response = true) {
        $response = parent::delete(false);
        return $this->generate_response($response, $print_response);
    }

}
sqlsrv_close( $conn);
$upload_handler = new CustomUploadHandler($options);