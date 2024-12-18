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
      $REG_Id = $row['REG_Id'];
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
      $PRY_PorcentajeMinOnline = $row['PRY_PorcentajeMinOnline'];
      $PRY_PorcentajeMinPresencial = $row['PRY_PorcentajeMinPresencial'];
      $PRY_ObjetivoGeneral = $row['PRY_ObjetivoGeneral'];
      $PRY_InformeFinalFecha = $row['PRY_InformeFinalFecha'];      
      $PRY_TipoMesa = $row['PRY_TipoMesa'];
      if($PRY_TipoMesa==1){
        $PRY_TipoMesaDescripcion="Mesa Bipartita";
      };
      if($PRY_TipoMesa==2){
        $PRY_TipoMesaDescripcion="Mesa Tripartita";
      };
      $RUB_Nombre = $row['RUB_Nombre'];
      $TEM_Descripcion = $row['TEM_Descripcion'];
      $PRY_DimensionDialogoSocial = $row['PRY_DimensionDialogoSocial'];
      //Personalizacion      

      //Fechas de cierre
      $PRY_InformeInicialFecha = $row['PRY_InformeInicialFecha'];
      $PRY_InformeConsensosFecha = $row['PRY_InformeConsensosFecha'];
      $PRY_InformeSistematizacionFecha = $row['PRY_InformeSistematizacionFecha'];
      $PRY_InformeParcialFecha = $row['PRY_InformeParcialFecha'];

      $PRY_InformeInicialFechaOriginal = $row['PRY_InformeInicialFechaOriginal'];
      $PRY_InformeConsensosFechaOriginal = $row['PRY_InformeConsensosFechaOriginal'];
      $PRY_InformeSistematizacionFechaOriginal = $row['PRY_InformeSistematizacionFechaOriginal'];
      $PRY_InformeParcialFechaOriginal = $row['PRY_InformeParcialFechaOriginal'];



      $PRY_FechaTramitacionContrato = $row['PRY_FechaTramitacionContrato'];
      //Fechas de cierre      

      //Responsables del proyecto
      $PRY_EncargadoProyecto = $row['PRY_EncargadoProyecto'];
      $PRY_EncargadoProyectoMail = $row['PRY_EncargadoProyectoMail'];
      $SEX_DescripcionEncargadoProyecto = $row['SEX_DescripcionEncargadoProyecto'];
      $PRY_EncargadoProyectoCelular = $row['PRY_EncargadoProyectoCelular'];
      $EDU_DescripcionEncargadoProyecto = $row['EDU_DescripcionEncargadoProyecto'];
      $PRY_EncargadoProyectoCarrera = $row['PRY_EncargadoProyectoCarrera'];

      $PRY_EncargadoActividades = $row['PRY_EncargadoActividades'];
      $PRY_EncargadoActividadesMail = $row['PRY_EncargadoActividadesMail'];
      $SEX_DescripcionEncargadoActividades = $row['SEX_DescripcionEncargadoActividades'];
      $PRY_EncargadoActividadesCelular = $row['PRY_EncargadoActividadesCelular'];
      $EDU_DescripcionEncargadoActividades = $row['EDU_DescripcionEncargadoActividades'];
      $PRY_EncargadoActividadesCarrera = $row['PRY_EncargadoActividadesCarrera'];

      $PRY_Facilitador = $row['PRY_Facilitador'];
      $PRY_FacilitadorMail = $row['PRY_FacilitadorMail'];
      $SEX_DescripcionFacilitador = $row['SEX_DescripcionFacilitador'];
      $PRY_FacilitadorCelular = $row['PRY_FacilitadorCelular'];
      $EDU_DescripcionFacilitador = $row['EDU_DescripcionFacilitador'];
      $PRY_FacilitadorCarrera = $row['PRY_FacilitadorCarrera'];
      $PRY_FacilitidorForEsp = $row['PRY_FacilitidorForEsp'];
      if($PRY_FacilitidorForEsp==1){
        $PRY_FacilitidorForEspTXT = 'Si';
      }else{
        $PRY_FacilitidorForEspTXT = 'No';
      }
      //Responsables del proyecto
      $MCZ_Descripcion = $row['DescripcionMacrozona'];
      $PRY_DiagnosticoSocioLaboral = $row['PRY_DiagnosticoSocioLaboral'];
      $PRY_MetodologiaResultadoEsperado = $row['PRY_MetodologiaResultadoEsperado'];
      $LIN_AgregaTematica = $row['LIN_AgregaTematica'];

      //Encargado audiovisual
      $PRY_EncargadoAudio= $row['PRY_EncargadoAudio'];
      $PRY_EncargadoAudioMail= $row['PRY_EncargadoAudioMail'];
      $SEX_DescripcionEncargadoAudio= $row['Sex_DescripcionEncargadoAudio'];
      $PRY_EncargadoAudioCelular= $row['PRY_EncargadoAudioCelular'];
      $EDU_DescripcionEncargadoAudio= $row['EDU_DescripcionEncargadoAudio'];
      $PRY_EncargadoAudioCarrera= $row['PRY_EncargadoAudioCarrera'];
      $PRY_EncargadoAudioForEsp= $row['PRY_EncargadoAudioForEsp'];
      if($PRY_EncargadoAudioForEsp==1){
            $PRY_EncargadoAudioForEspTXT = 'Si';
      }else{
            $PRY_EncargadoAudioForEspTXT = 'No';
      }
      $PRY_DiagnosticoSocioLaboral = $row['PRY_DiagnosticoSocioLaboral'];
}
sqlsrv_free_stmt( $stmt);
//print_r($PRY_Carpeta);
if($PRY_Carpeta==''){
	die('{\"response\":\"error\",\"data\":\"Carpeta no válida\":}');
};

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
$pdf->SetTitle('Informe Avances Eficacia');
$pdf->SetSubject($ver);
$pdf->SetKeywords('TCPDF, PDF, mesa, dialogo, social');

// set default header data
//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
$pdf->SetHeaderData("logo_subtrab.jpg", 30, 'Informe Avances Eficacia' , $PRY_Nombre." Nro.: ".$data->PRY_Id."\nEmpresa Ejecutora: ".$PRY_EmpresaEjecutora."\nROL/RUT: ".$EME_Rol."\Encargado/a del Pryecto: ".$PRY_EncargadoProyecto."\n\nSantiago ".date('d-m-o'));

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
    <th scope="col" width="33%">Coordinador/a</th>
    <th scope="col" width="33%">Revisor</th>    
    <th scope="col" width="33%">Metodología</th>
  </tr>
  <tr>
    <td width="35%">'.$USR_NombreEjecutor." ".$USR_ApellidoEjecutor.'</td>
    <td width="35%">'.$USR_NombreRevisor." ".$USR_ApellidoRevisor.'</td>    
    <td width="20%">'.$MET_Descripcion.'</td>
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
                    <th scope="col" width="50%">Monto</th>
                    <th scope="col" width="50%">Tipo de Mesa</th>
                  </tr>
                  <tr>                    
                    <td width="50%">'.$PRY_MontoAdjudicado.'</td>
                    <td width="50%">'.$PRY_TipoMesaDescripcion.'</td>                    
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


// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Fechas de Cierre</h4>
                <h5>Fechas de Cierre Informadas</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 1</th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 2</th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 3</th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 4</th>
                </tr>
                <tr>
                    <td width="25%">'.$PRY_InformeInicialFecha.'</td>
                    <td width="25%">'.$PRY_InformeConsensosFecha.'</td>
                    <td width="25%">'.$PRY_InformeParcialFecha.'</td>
                    <td width="25%">'.$PRY_InformeSistematizacionFecha.'</td>
                </tr>
                </table>                
                <h5>Fecha de Cierre Originales</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 1</th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 2</th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 3 </th>
                    <th scope="col" width="25%">Fecha Cierre Informe Nro 4 </th>
                </tr>
                <tr>
                    <td width="25%">'.$PRY_InformeInicialFechaOriginal.'</td>
                    <td width="25%">'.$PRY_InformeConsensosFechaOriginal.'</td>
                    <td width="25%">'.$PRY_InformeParcialFechaOriginal.'</td>
                    <td width="25%">'.$PRY_InformeSistematizacionFechaOriginal.'</td>
                </tr>
                </table>
                <h5>Fecha Tramitación de Contrato</h5>
                <table  border="0">
                <tr>
                    <th scope="col" width="100%">Fecha Cierre Informe Incial</th>                    
                </tr>
                <tr>
                    <td width="100%">'.$PRY_FechaTramitacionContrato.'</td>                    
                </tr>
                </table>
                
                <br><br>';


// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Responsables del Proyecto</h4>
    <h5>Coordinador/a de proyecto</h5>
    <table border="0">
    <tr>
        <th scope="col">Nombre</th>
        <th scope="col">Correo electrónico</th>
        <th scope="col">Sexo</th>
        <th scope="col">Teléfono</th>
        <th scope="col">Nivel Educacional</th>
        <th scope="col">Nombre Carrera</th>
    </tr>
    <tr>
        <td>'.$PRY_EncargadoProyecto.'</td>
        <td>'.$PRY_EncargadoProyectoMail.'</td>
        <td>'.$SEX_DescripcionEncargadoProyecto.'</td>
        <td>'.$PRY_EncargadoProyectoCelular.'</td>
        <td>'.$EDU_DescripcionEncargadoProyecto.'</td>
        <td>'.$PRY_EncargadoProyectoCarrera.'</td>
    </tr>
    </table><br>    
    <h5>Encargado/a Social</h5>
    <table border="0">
    <tr>
        <th scope="col">Nombre</th>
        <th scope="col">Correo electrónico</th>
        <th scope="col">Sexo</th>
        <th scope="col">Teléfono</th>
        <th scope="col">Nivel Educacional</th>
        <th scope="col">Nombre Carrera</th>
        <th scope="col">Formación Especializada</th>
    </tr>
    <tr>
        <td>'.$PRY_Facilitador.'</td>
        <td>'.$PRY_FacilitadorMail.'</td>
        <td>'.$SEX_DescripcionFacilitador.'</td>
        <td>'.$PRY_FacilitadorCelular.'</td>
        <td>'.$EDU_DescripcionFacilitador.'</td>
        <td>'.$PRY_FacilitadorCarrera.'</td>
        <td>'.$PRY_FacilitidorForEspTXT.'</td>
    </tr>
    </table><br>
    <h5>Encargado/a Audiovisual</h5>
    <table border="0">
    <tr>
        <th scope="col">Nombre</th>
        <th scope="col">Correo electrónico</th>
        <th scope="col">Sexo</th>
        <th scope="col">Teléfono</th>
        <th scope="col">Nivel Educacional</th>
        <th scope="col">Nombre Carrera</th>
        <th scope="col">Formación Especializada</th>
    </tr>
    <tr>
        <td>'.$PRY_EncargadoAudio.'</td>
        <td>'.$PRY_EncargadoAudioMail.'</td>
        <td>'.$SEX_DescripcionEncargadoAudio.'</td>
        <td>'.$PRY_EncargadoAudioCelular.'</td>
        <td>'.$EDU_DescripcionEncargadoAudio.'</td>
        <td>'.$PRY_EncargadoAudioCarrera.'</td>
        <td>'.$PRY_EncargadoAudioForEspTXT.'</td>
    </tr>
    </table><br>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Metodología de Investigación</h4>    
    <table border="0">
    <tr>
        <th scope="col">Metodología de Investigación</th>
    </tr>
    <tr>
        <td>'.$PRY_DiagnosticoSocioLaboral.'</td>
    </tr>
    </table><br>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

if($LIN_AgregaTematica==1){
    $pdf->AddPage('L','A4');
    $html = $htmlstyle.'<h4>Exposición Adicional</h4>
                    <h4>Exposición(es) Adicional(es) incorporada(s)</h4>            
                    <table  border="0">
                    <tr>
                        <th>id</th>
                        <th>id</th>
                        <th>Exposición</th>
                    </tr>';
    $datos = '<tr>
                <td colspan="3" style="text-align:center">Sin datos</td>
            </tr>';
    $datosTabla = '';                

    $tsql_callSP = "spTematicaProyecto_Listar ?, ?";
    $params = array(   
                array($data->PRY_Id, SQLSRV_PARAM_IN),
                array($data->PRY_Identificador, SQLSRV_PARAM_IN),
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
    $html = $html.$datos.'</table>';

    // reset pointer to the last page
    $pdf->lastPage();
    // output the HTML content
    $pdf->writeHTML($html, true, false, true, false, '');
}


// ---------------------------------------------------------
//Cierre de la conexion
sqlsrv_close( $conn);

//Close and output PDF document
//$pdf->Output('informecreacionescuela.pdf', 'I');



$INF_Path='d:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/informes/informedesarrollo/';
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