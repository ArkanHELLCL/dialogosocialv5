<?php
//Library
require_once('../../../../../appl/TCPDF-master/tcpdf.php');
//Connection
require_once('../../../../../include/template/dsn.php');

//Rescatabndo JSON POST
// Takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json);

//Datos BD
$tsql_callSP = "spProyecto_Consultar ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN),		  
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$PRY_Carpeta='';
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{  	  
      $PRY_Carpeta = $row['PRY_Carpeta'];
      $LIN_AgregaTematica = $row['LIN_AgregaTematica'];
      //Personalizacion      
      $PRY_Nombre = $row['PRY_Nombre'];
	  $LFO_Id = $row['LFO_Id'];;
      $PRY_EncargadoProyecto = $row['PRY_EncargadoProyecto'];
      $PRY_EmpresaEjecutora = $row['PRY_EmpresaEjecutora'];
      $EME_Rol = $row['EME_Rol'];
      $PRY_AnioProyecto = $row['PRY_AnioProyecto'];
      $USR_NombreEjecutor = $row['USR_NombreEjecutor'];
      $USR_ApellidoEjecutor = $row['USR_ApellidoEjecutor'];
      $USR_NombreRevisor = $row['USR_NombreRevisor'];
      $USR_ApellidoRevisor = $row['USR_ApellidoRevisor'];
      $MET_Id = $row['MET_Id'];
      $MET_Descripcion = $row['MET_Descripcion'];
      $REG_Nombre = $row['REG_Nombre'];
      $PRY_UrlClase = $row['PRY_UrlClase'];
      $COM_Nombre = $row['COM_Nombre'];
      $PRY_DireccionEjecucion = $row['PRY_DireccionEjecucion'];
      $PRY_HorasPedagogicasMin = $row['PRY_HorasPedagogicasMin'];
      $PRY_MontoAdjudicado = $row['PRY_MontoAdjudicado'];
      $PRY_CodigoAsociado = $row['PRY_CodigoAsociado'];
      $PRY_CodigoAsociado = $row['PRY_CodigoAsociado'];
      $PRY_IdLicitacion = $row['PRY_IdLicitacion'];
      $PRY_NombreLicitacion = $row['PRY_NombreLicitacion'];
      $FON_Nombre = $row['FON_Nombre'];
      $PRY_NumAnoExperiencia = $row['PRY_NumAnoExperiencia'];
      $PRY_PorcentajeMinOnline = $row['PRY_PorcentajeMinOnline'];
      $PRY_PorcentajeMinPresencial = $row['PRY_PorcentajeMinPresencial'];
      $PRY_ObjetivoGeneral = $row['PRY_ObjetivoGeneral'];
      $PRY_InformeFinalFecha = $row['PRY_InformeFinalFecha'];
      $LFO_PorcentajeMinEjecutado = $row['LFO_PorcentajeMinEjecutado'];
      if($LFO_PorcentajeMinEjecutado=='' or is_null($LFO_PorcentajeMinEjecutado)) {
        $LFO_PorcentajeMinEjecutado = 0;
      };

      //Personalizacion      

      //Fechas de cierre
      $PRY_InformeInicioFecha = $row['PRY_InformeInicioFecha'];
      $PRY_InformeParcialFecha = $row['PRY_InformeParcialFecha'];
      $PRY_InformeInicioFechaOriginal = $row['PRY_InformeInicioFechaOriginal'];
      $PRY_InformeParcialFechaOriginal = $row['PRY_InformeParcialFechaOriginal'];
      $PRY_InformeFinalFechaOriginal = $row['PRY_InformeFinalFechaOriginal'];
      $PRY_FechaTramitacionContrato = $row['PRY_FechaTramitacionContrato'];
      //Fechas de cierre

      //Rendicion
      $PRY_Responsable1 = $row['PRY_Responsable1'];
      $PRY_Responsable2 = $row['PRY_Responsable2'];
      //Rendicion

}
sqlsrv_free_stmt( $stmt);
//print_r($PRY_Carpeta);
if($PRY_Carpeta==''){
	die('{\"response\":\"error\",\"data\":\"Carpeta no válida\":}');
};

//Focalizacion de beneficiarios      
$tsql_callSP = "spGruposFocalizacionxProyecto_Consultar ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN),		  
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $GRF_Id = $row['GRF_Id'];
    if($row['GRF_Discapacidad']==1){
        $GRF_Discapacidad = 'Si';
    }else{
        $GRF_Discapacidad = 'No';
    };
    if($row['GRF_AccesoInternet']==1){
        $GRF_AccesoInternet = 'Si';
    }else{
        $GRF_AccesoInternet = 'No';
    };
    if($row['GRF_PuebloOriginario']==1){
        $GRF_PuebloOriginario = 'Si';
    }else{
        $GRF_PuebloOriginario = 'No';
    };
    if($row['GRF_PerteneceSindicato']==1){
        $GRF_PerteneceSindicato = 'Si';
    }else{
        $GRF_PerteneceSindicato = 'No';
    };    

    if($row['GRF_PermisoSindical']==1){
        $GRF_PermisoSindical = 'Si';
    }else{
        $GRF_PermisoSindical = 'No';
    };
    if($row['GRF_DirigenteSindical']==1){
        $GRF_DirigenteSindical = 'Si';
    }else{
        $GRF_DirigenteSindical = 'No';
    };
    if($row['GRF_CursoSindical']==1){
        $GRF_CursoSindical = 'Si';
    }else{
        $GRF_CursoSindical = 'No';
    };
    if($row['GRF_CargoDirectivoOrganizacion']==1){
        $GRF_CargoDirectivoOrganizacion = 'Si';
    }else{
        $GRF_CargoDirectivoOrganizacion = 'No';
    };
    break;
}
sqlsrv_free_stmt( $stmt);
//Focalizacion de beneficiarios

// Extend the TCPDF class to create custom Header and Footer
class MYPDF extends TCPDF {    
    //Page header
    /*public function Header() {
        // Logo
        $image_file = K_PATH_IMAGES.'logo_example.jpg';
        $this->Image($image_file, 10, 10, 15, '', 'JPG', '', 'T', false, 300, '', false, false, 0, false, false, false);
        // Set font
        $this->SetFont('helvetica', 'B', 20);
        // Title
        $this->Cell(0, 15, '<< TCPDF Example 003 >>', 0, false, 'C', 0, '', 0, false, 'M', 'M');
    }*/

    // Page footer
    public function Footer() {
        // Position at 15 mm from bottom
        $this->SetY(-15);
        // Set font
        $this->SetFont('helvetica', '', 8);
        // Custom footer HTML
        $this->html = '<hr><br><span>'.$this->VerSis.'</span><br><b>página '.$this->getAliasNumPage().'/'.$this->getAliasNbPages().'</b>';
        $this->writeHTML($this->html, true, false, true, false, '');
    }
}

// create new PDF document
//$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

// set document information
//Version del sistema dsn.php
$pdf->VerSis = $ver;
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor('SUBTRAB');
//pdf->SetTitle($_POST["titulo"]);
$pdf->SetTitle('Informe Creación Escuela');
$pdf->SetSubject($ver);
$pdf->SetKeywords('TCPDF, PDF, mesa, dialogo, social');

// set default header data
//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
$pdf->SetHeaderData("logo_subtrab.jpg", 30, 'Informe Creación Escuela' , $PRY_Nombre." Nro.: ".$data->PRY_Id."\nEmpresa Ejecutora: ".$PRY_EmpresaEjecutora."\nROL/RUT: ".$EME_Rol."\nEncargado del Proyecto: ".$PRY_EncargadoProyecto."\n\nSantiago ".date('d-m-o'));

// set header and footer fonts
$pdf->setHeaderFont(Array(PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN));
$pdf->setFooterFont(Array(PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA));

// set default monospaced font
$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

// set margins
//$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
$pdf->SetMargins(PDF_MARGIN_LEFT, 40, PDF_MARGIN_RIGHT);
$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

// set auto page breaks
$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

// set image scale factor
$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

// set some language-dependent strings (optional)
if (@file_exists(dirname(__FILE__).'/lang/eng.php')) {
    require_once(dirname(__FILE__).'/lang/eng.php');
    $pdf->setLanguageArray($l);
}

// ---------------------------------------------------------

// set font
$pdf->SetFont('dejavusans', '', 10);

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Print a table

// add a page
//$pdf->AddPage();
$pdf->AddPage('L','A4');

// create some HTML content
$htmlstyle = '<style>	
h1 {
    display: block;
    font-size: 12pt;		
    margin-bottom: 0px;
    margin-left: 0;
    margin-right: 0;
    font-weight: bold;
    padding: 0;
    margin: 0;
}
h4 {
    display: block;
    font-size: 12pt;
    margin-top: 0px;
    margin-bottom: 1.33em;
    margin-left: 0;
    margin-right: 0;		
    font-weight: bold;
    padding-top: 10px;
}
h5 {
    display: block;
    font-size: 10pt;
    margin-top: 0px;
    margin-bottom: .7em;
    margin-left: 0;
    margin-right: 0;
    font-weight: bold;
}	
table {     
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;		
    width: 100%; 
    text-align: left;    
    border-collapse: collapse; 
}

th {     
    font-size: 12px;
    font-weight: bold;
    padding: 2px;		
    background-color: #b9c9fe;    	
}

td { 
    font-size: 11px;
    padding: 2px;		
    background-color: #e8edff;     		
    color: #669;    		
}		
</style>';

$html = $htmlstyle.'<h4>Personalización</h4>
<table  border="0">
  <tr>
    <th scope="col" width="50%">Nombre</th>
    <th scope="col" width="50%">Año</th>
  </tr>
  <tr>
    <td width="50%">'.$PRY_Nombre.'</td>
    <td width="50%">'.$PRY_AnioProyecto.'</td>
  </tr>
</table>                                
<table  border="0">
  <tr>
    <th scope="col">Empresa Ejecutora</th>
    <th scope="col">ROL/RUT</th>
  </tr>
  <tr>
    <td>'.$PRY_EmpresaEjecutora.'</td>
    <td>'.$EME_Rol.'</td>
  </tr>				  
</table>                
<table  border="0">
  <tr>
    <th scope="col" width="35%">Encargado/a de plataforma</th>
    <th scope="col" width="35%">Revisor</th>    
    <th scope="col" width="30%">Modalidad</th>
  </tr>
  <tr>
    <td width="35%">'.$USR_NombreEjecutor." ".$USR_ApellidoEjecutor.'</td>
    <td width="35%">'.$USR_NombreRevisor." ".$USR_ApellidoRevisor.'</td>    
    <td width="30%">'.$MET_Descripcion.'</td>
  </tr>
</table>';
if($MET_Id==1){
    $html = $html.'<table  border="0">
					  <tr>
						<th scope="col" width="100%">Región</th>						
					  </tr>
					  <tr>
						<td width="100%">'.$REG_Nombre.'</td>						
					  </tr>
					</table>
					<table  border="0">
					  <tr>						
						<th scope="col">URL</th>
					  </tr>
					  <tr>						
						<td>'.$PRY_UrlClase.'</td>
					  </tr>
					</table>';
};
if($MET_Id==2){
    $html = $html.'<table  border="0">
					  <tr>
						<th scope="col" width="50%">Región</th>
						<th scope="col" width="50%">Comuna</th>
					  </tr>
					  <tr>
						<td width="50%">'.$REG_Nombre.'</td>
						<td width="50%">'.$COM_Nombre.'</td>
					  </tr>
					</table>
					<table  border="0">
					  <tr>
						<th scope="col">Dirección</th>						
					  </tr>
					  <tr>
						<td>'.$PRY_DireccionEjecucion.'</td>						
					  </tr>
					</table>';
};
if($MET_Id==3){
    $html = $html.'<table  border="0">
					  <tr>
						<th scope="col" width="50%">Región</th>
						<th scope="col" width="50%">Comuna</th>
					  </tr>
					  <tr>
						<td width="50%">'.$REG_Nombre.'</td>
						<td width="50%">'.$COM_Nombre.'</td>
					  </tr>
					</table>
					<table  border="0">
					  <tr>
						<th scope="col">Dirección</th>
						<th scope="col">URL</th>
					  </tr>
					  <tr>
						<td>'.$PRY_DireccionEjecucion.'</td>
						<td>'.$PRY_UrlClase.'</td>
					  </tr>
					</table>';
};
$sw = false;
$ancho=50;
If(($PRY_CodigoAsociado!="") and (!is_null($PRY_CodigoAsociado)) and $PRY_CodigoAsociado>0){
    $sw = true;
    $ancho=40;
}
$html = $html.'<table  border="0">
                  <tr>
                    <th scope="col" width="50%">Horas Pegagógicas Mínimas</th>
                    <th scope="col" width="50%">Monto</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_HorasPedagogicasMin.'</td>
                    <td width="50%">'.$PRY_MontoAdjudicado.'</td>
                  </tr>				  				  
                </table>
				<table  border="0">
                  <tr>
                    <th scope="col" width="20%">Id Licitación</th>
                    <th scope="col" width="30%">Nombre Licitación</th>
					<th scope="col" width="'.$ancho.'%">Ítem Presupuestario</th>';

If($sw){
    $html = $html.'<th scope="col" width="10%">Proyecto Asociado</th>';  
};
$html = $html.'</tr>
                  <tr>
                    <td width="20%">'.$PRY_IdLicitacion.'</td>
                    <td width="30%">'.$PRY_NombreLicitacion.'</td>
					<td width="'.$ancho.'%">'.$FON_Nombre.'</td>';

If($sw){
    $html = $html.'<td width="10%">'.$PRY_CodigoAsociado.'</td>';
};
$html = $html.'</tr>
            </table>';

if($MET_Id==1){
    $html = $html.'<table border=0>
                    <tr>
                        <th scope="col" width="50%">Porcentanje mínimo clases online</th>
                        <th scope="col" width="50%">Porcentanje mínimo planificación ejecutada</th>
                    </tr>
                    <tr>
                        <td width="50%">'.$PRY_PorcentajeMinOnline.'%</td>
                        <td width="50%">'.$LFO_PorcentajeMinEjecutado.'%</td>
                    </tr>
                  </table>';
};
if($MET_Id==2){
    $html = $html.'<table border=0>
                    <tr>
                        <th scope="col" width="50%">Porcentanje mínimo clases presenciales</th>
                        <th scope="col" width="50%">Porcentanje mínimo planificación ejecutada</th>
                    </tr>
                    <tr>
                        <td width="50%">'.$PRY_PorcentajeMinPresencial.'%</td>
                        <td width="50%">'.$LFO_PorcentajeMinEjecutado.'%</td>
                    </tr>
                  </table>';
};
if($MET_Id==3){
    $html = $html.'<table border=0>
                    <tr>
                        <th scope="col" width="33%">Porcentanje mínimo clases online</th>
                        <th scope="col" width="33%">Porcentanje mínimo clases presenciales</th>
                        <th scope="col" width="33%">Porcentanje mínimo planificación ejecutada</th>
                    </tr>
                    <tr>
                        <td width="33%">'.$PRY_PorcentajeMinOnline.'%</td>
                        <td width="33%">'.$PRY_PorcentajeMinPresencial.'%</td>
                        <td width="33%">'.$LFO_PorcentajeMinEjecutado.'%</td>
                    </tr>
                  </table>';
};

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Focalización de Beneficiarios</h4>
            <h5>Seleción de grupos focales (Si/No)</h5>
            <table  border="0">
                <tr>
                    <th scope="col" width="25%">Discapacidad</th>
                    <th scope="col" width="25%">Acceso a internet</th>
                    <th scope="col" width="25%">Pueblo Originario</th>
                    <th scope="col" width="25%">Pertenece Sindicato</th>
                </tr>
                <tr>
                    <td width="25%">'.$GRF_Discapacidad.'</td>
                    <td width="25%">'.$GRF_AccesoInternet.'</td>
                    <td width="25%">'.$GRF_PuebloOriginario.'</td>
                    <td width="25%">'.$GRF_PerteneceSindicato.'</td>
                </tr>
            </table>
            <table  border="0">
                <tr>
                    <th scope="col" width="25%">Permiso Sindical</th>
                    <th scope="col" width="25%">Dirigente Sindical</th>
                    <th scope="col" width="25%">Curso Sindical</th>
                    <th scope="col" width="25%">Cargo Directivo</th>
                </tr>
                <tr>
                    <td width="25%">'.$GRF_PermisoSindical.'</td>
                    <td width="25%">'.$GRF_DirigenteSindical.'</td>
                    <td width="25%">'.$GRF_CursoSindical.'</td>
                    <td width="25%">'.$GRF_CargoDirectivoOrganizacion.'</td>
                </tr>
            </table>';


$html = $html.'<h5>Grupos incorporados (Multiselección)</h5>
            <table  border="0">
                <tr>
                    <th>Id</th>
                    <th>Nacionalidad</th>
                    <th>Sexo</th>
                    <th>Educación</th>
                    <th>Discapacidad</th>
                    <th>Rubro</th><!--se cambia rubto por rubro corrección gramatica-->
                    <th>Trabajador</th>
                    <th>Tramo Etario</th>1
                </tr>';
$datos = '<tr>
            <td colspan="8" style="text-align:center">Sin datos</td>
        </tr>';

$tsql_callSP = "spGruposFocalizacionMultiseleccion_Listar ?";
$params = array(   
            array($GRF_Id, SQLSRV_PARAM_IN)            
    ); 
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{              
    $datosTabla = $datosTabla.'<tr>
                <td>'.$row['GFM_Id'].'</td>
                <td>'.$row['NAC_Nombre'].'</td>
                <td>'.$row['SEX_Descripcion'].'</td>
                <td>'.$row['EDU_Nombre'].'</td>
                <td>'.$row['TDI_Nombre'].'</td>
                <td>'.$row['RUB_Nombre'].'</td>
                <td>'.$row['TTR_Nombre'].'</td>
                <td>'.$row['TRE_Descripcion'].'</td>
            </tr>';
};
if(strlen($datosTabla)>0){
    $datos=$datosTabla;
}
$html = $html.$datos.'</table>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Fechas de Cierre</h4>
                <h5>Fechas de Cierre Informadas</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 1</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 2</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 3</th>
                </tr>
                <tr>
                    <td width="33%">'.$PRY_InformeInicioFecha.'</td>
                    <td width="33%">'.$PRY_InformeParcialFecha.'</td>
                    <td width="33%">'.$PRY_InformeFinalFecha.'</td>
                </tr>
                </table>                
                <h5>Fecha de Cierre Originales</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 1</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 2</th>
                    <th scope="col" width="33%">Fecha Cierre Informe Nro 3</th>
                </tr>
                <tr>
                    <td width="33%">'.$PRY_InformeInicioFechaOriginal.'</td>
                    <td width="33%">'.$PRY_InformeParcialFechaOriginal.'</td>
                    <td width="33%">'.$PRY_InformeFinalFechaOriginal.'</td>
                </tr>
                </table>
                <h5>Fecha Tramitación de Contratos</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="100%">Fecha Tramitación de Contratos</th>                    
                </tr>
                <tr>
                    <td width="100%">'.$PRY_FechaTramitacionContrato.'</td>                    
                </tr>
                </table>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Redes de Apoyo</h4>
            <h5>Sindicatos</h5>
            <table  border="0">
                <tr>
                    <th scope="col">Organización Sindical</th>
                    <th scope="col">Afilición Central</th> 
                    <th scope="col">Rubro</th>
                    <th scope="col">Compromiso</th>
                </tr>';
$datos = '<tr>
            <td colspan="4" style="text-align:center">Sin datos</td>
        </tr>';
$datosTabla = '';

$tsql_callSP = "spPatrocinio_Listar ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN)            
    ); 
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{              
    $datosTabla = $datosTabla.'<tr>
                <td>'.$row['SIN_Nombre'].'</td>
                <td>'.$row['ACE_Nombre'].'</td>
                <td>'.$row['RUB_Nombre'].'</td>
                <td>'.$row['PAT_Compromiso'].'</td>
            </tr>';
};
if(strlen($datosTabla)>0){
    $datos=$datosTabla;
}
$html = $html.$datos.'</table>';
$html = $html.'<h5>Organizaciones Civiles</h5>
            <table  border="0">
                <tr>
                    <th scope="col">Organización Civil</th>                    
                    <th scope="col">Rubro</th>
                    <th scope="col">Compromiso</th>
                </tr>';
$datos = '<tr>
            <td colspan="3" style="text-align:center">Sin datos</td>
        </tr>';
$datosTabla = '';

$tsql_callSP = "spPatrocinioCiviles_Listar ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN)            
    ); 
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{              
    $datosTabla = $datosTabla.'<tr>
                <td>'.$row['CIV_Nombre'].'</td>
                <td>'.$row['RUB_Nombre'].'</td>                
                <td>'.$row['PCI_Compromiso'].'</td>
            </tr>';
};
if(strlen($datosTabla)>0){
    $datos=$datosTabla;
}
$html = $html.$datos.'</table>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle;
if($LIN_AgregaTematica){    
    $html = $html.'<h4>Módulos Adicionales</h4>            
                <table  border="0">
                    <tr>
                        <th scope="col">Id Temática</th>
                        <th scope="col">Id Perspectiva</th> 
                        <th scope="col">Módulo</th>                    
                    </tr>';
    $datos = '<tr>
                <td colspan="3" style="text-align:center">Sin datos</td>
            </tr>';
    $datosTabla = '';

    $tsql_callSP = "spTematicaProyecto_Listar ?, ?";
    $params = array(   
                array($data->PRY_Id, SQLSRV_PARAM_IN),
                array($data->PRY_Identificador, SQLSRV_PARAM_IN)
        ); 
    $stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
    while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
    {              
        $datosTabla = $datosTabla.'<tr>
                    <td>'.$row['TPR_Id'].'</td>
                    <td>'.$row['PPR_Id'].'</td>
                    <td>'.$row['TPR_Nombre'].'</td>                    
                </tr>';
    };
    if(strlen($datosTabla)>0){
        $datos=$datosTabla;
    }
    $html = $html.$datos.'</table><br><br>';    
}

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');


// ---------------------------------------------------------
//Cierre de la conexion
sqlsrv_close( $conn);

//Close and output PDF document
//$pdf->Output('informecreacionescuela.pdf', 'I');



$INF_Path='d:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/informes/informecreacion/';
if (!is_dir($INF_Path)) {
    mkdir($INF_Path, 0777, true);
}

//Creando fecha juliana
$dia=date("d");
$mes=date("m");
$anio=date("Y");
$jdate=juliantojd($mes,$dia,$anio);
//Creando respaldo del archivo generado
$name = explode('.',$data->FileName);
$pdf->Output($INF_Path.$name[0].$jdate.time().".pdf", 'F');	//Grabar
//Close and output PDF document
//$pdf->Output($_POST["salida"], 'I');	//Visualizar
//$pdf->Output($_POST["salida"], 'D');	//Bajar
$pdf->Output($INF_Path.$data->FileName, 'F');	//Grabar

$response = "{\"response\":\"ok\"}";
echo $response;
//============================================================+
// END OF FILE
//============================================================+