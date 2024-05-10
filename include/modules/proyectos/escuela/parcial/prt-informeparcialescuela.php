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
      $PRY_Nombre = $row['PRY_Nombre'];
      $PRY_EmpresaEjecutora = $row['PRY_EmpresaEjecutora'];
      $EME_Rol = $row['EME_Rol'];
      $PRY_EncargadoProyecto = $row['PRY_EncargadoProyecto'];
      $LIN_Id = $row['LIN_Id'];      

      //Deserciones Manuales
      $LIN_Hombre = $row['LIN_Hombre'];
      $LIN_Mujer = $row['LIN_Mujer'];
      //Deserciones Manuales
      //Planificación
      $LFO_PorcentajeMinEjecutado=$row['LFO_PorcentajeMinEjecutado'];
      $PRY_PorcentajeEjecutadoAprobado=$row['PRY_PorcentajeEjecutadoAprobado'];
      $PRY_FechaPorcentajeEjecutado=$row['PRY_FechaPorcentajeEjecutado'];
      //Planificación
      //Seguimiento de ejecucion
      $PRY_Facilitadores = $row['PRY_Facilitadores'];
      $PRY_Obstaculizadores = $row['PRY_Obstaculizadores'];
      $PRY_MecMitigacion = $row['PRY_MecMitigacion'];
      //Seguimiento de ejecucion
}
sqlsrv_free_stmt( $stmt);
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
$pdf->SetTitle('Informe Desarrollo Escuela'); //cambio de BFJ Parcial a Desarrollo
$pdf->SetSubject($ver);
$pdf->SetKeywords('TCPDF, PDF, mesa, dialogo, social');

// set default header data
//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
$pdf->SetHeaderData("logo_subtrab.jpg", 30, 'Informe Desarrollo Escuela' , $PRY_Nombre." Nro.: ".$data->PRY_Id."\nEmpresa Ejecutora: ".$PRY_EmpresaEjecutora."\nROL/RUT: ".$EME_Rol."\nEncargado del Proyecto: ".$PRY_EncargadoProyecto."\n\nSantiago ".date('d-m-o'));

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

$html = $htmlstyle.'<h4>Deserciones Manuales</h4>
                <h5>Causas, razones y cantidad de deserciones</h5>
                <table border="0">
                <tr>
                    <th rowspan="2">Causa</th>
                    <th rowspan="2">Razón</th>';
                    if($LIN_Hombre and $LIN_Mujer){                        
                        $html = $html.'<th colspan="3" style="text-align:center;">Cantidad de Alumnos/as</th>';
                    }else{
                        if($LIN_Mujer and !$LIN_Hombre){
                            $html = $html.'<th colspan="3">Cantidad de Alumnas</th>';
                        }else{
                            if(!$LIN_Mujer and $LIN_Hombre){
                                $html = $html.'<th colspan="3">Cantidad de Alumnos</th>';
                            }else{
                                $html = $html.'<th colspan="3">No definido</th>';
                            };
                        };
                    };
                    $html = $html.'</tr>
                                <tr>';
                    if($LIN_Hombre and $LIN_Mujer){
                        $html = $html.'<th>Hombres</th>
                                    <th>Mujeres</th>';
                    };
                    $html = $html.'<th>Total</th>
                </tr>';
                
$tsql_callSP = "spAlumnoProyecto_DesercionResumen ?, ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->ds5_usrid, SQLSRV_PARAM_IN),
            array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
    );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe = false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{  	  
    $existe = true;
    $html = $html.'<tr>';
    if($CDE_InfoCausaId!=$row['CDE_InfoCausaId']){
        $html = $html.'<td rowspan="'.$row['RazonesxCausa'].'" scope="row">'.trim($row['CDE_InfoCausaDesercion']).'</td>';
    };					
    $html = $html.'<td>'.trim($row['RDE_InfoRazonDesercion']).'</td>';
    if($LIN_Hombre and $LIN_Mujer){
        $html = $html.'<td>'.$row['Masculino'].'</td>
        <td>'.$row['Femenino'].'</td>';
    };
    $html = $html.'<td>'.$row['Masculino']+$row['Femenino'].'</td></tr>';
    $CDE_InfoCausaId=$row['CDE_InfoCausaId'];
};
if(!$existe){
    $html = $html.'<tr>
                <td colspan="5" style="text-align:center;">Tabla sin datos</td>
            </tr>';
};
$html = $html.'</table>
                <h5>Observaciones sobre las deserciones</h5>
                <table border="0">
                <tr>
                    <th>Alumno/a</th>
                    <th>Causa</th>
                    <th>Razón</th>
                    <th>Observación</th>
                </tr>';
$tsql_callSP = "spAlumnoProyecto_Listar ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN)            
    );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe = false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{  	  
    $existe = true;
    if($row['EST_Estado']==6 and $row['EST_InfoEstadoAcademico']!=99) {
        $html = $html.'<tr>
                    <td>'.$row['ALU_Nombre'].' '.$row['ALU_Apellido'].'</td>
                    <td>'.$row['CDE_InfoCausaDesercion'].'</td>
                    <td>'.$row['RDE_InfoRazonDesercion'].'</td>
                    <td>'.$row['EST_InfoObservaciones'].'</td>
                </tr>';
    };
}
$html = $html.'</table>
            <h5>Fecha primera deserción</h5>
            <table border="0">
            <tr>
                <th>Fecha</th>
            </tr>
            <tr>
                <td>';
$tsql_callSP = "spAlumnoProyecto_DesercionInfo ?, ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->ds5_usrid, SQLSRV_PARAM_IN),
            array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
    );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe = false;
$FechaPrimeraDesercion='';
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe = true;
    if(!is_null($row['FechaPrimeraDesercion'])){
        $FechaPrimeraDesercion = $row['FechaPrimeraDesercion']->format('Y-m-d');
        if ($FechaPrimeraDesercion) {      
        } else { // format failed
            $FechaPrimeraDesercion='';
        }    
    }else{
        $FechaPrimeraDesercion='';
    }
    break;
};

$html = $html.$FechaPrimeraDesercion.'</td>
                                    </tr>
                                </table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');                    

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Nuevas Deserciones e Incorporaciones</h4>
                <h5>Deserciones (Posteriores a la fecha de cierre del informe Inicio)</h5>
                <table border="0">
                <tr>
                    <th>#</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Rut</th>
                    <th>Fecha</th>
                </tr>';
$tsql_callSP = "spAlumnoProyecto_DesercionResumen_PorFechaCierreInforme ?, 1, ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->ds5_usrid, SQLSRV_PARAM_IN),
            array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
    );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe = false;
$x=0;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe = true;
    $x=$x+1;
    $EST_FechaCreacionRegistro = $row['EST_FechaCreacionRegistro']->format('Y-m-d H:i:s');
    if ($EST_FechaCreacionRegistro) {      
    } else { // format failed
        $EST_FechaCreacionRegistro='';
    }
    $html = $html.'<tr>
					<td>'.$x.'</td>
					<td>'.$row['ALU_Nombre'].' '.$row['ALU_ApellidoPaterno'].'</td>
					<td>'.$row['SEX_Descripcion'].'</td>
					<td>'.$row['ALU_Rut'].'</td>
					<td>'.$EST_FechaCreacionRegistro.'</td>
				</tr>';
};
if(!$existe){
    $html = $html.'<tr>
                <td colspan="5" style="text-align:center;">Tabla sin datos</td>
            </tr>';
};

$html = $html.'</table>
                <h5>Incorporaciones (Posteriores a la fecha de cierre del informe Inicio)</h5>
                <table border="0">
                <tr>
                    <th>#</th>
                    <th>Nombre</th>
                    <th>Sexo</th>
                    <th>Rut</th>
                    <th>Incorporación</th>
                    <th>Estado</th>
                </tr>';
$tsql_callSP = "spAlumnoProyecto_IncorporacionResumen_PorFechaCierreInforme ?, 1, ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->ds5_usrid, SQLSRV_PARAM_IN),
            array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
    );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe = false;
$x=0;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe = true;
    $x=$x+1;
    $EST_FechaCreacionRegistro = $row['EST_FechaCreacionRegistro']->format('Y-m-d H:i:s');
    if ($EST_FechaCreacionRegistro) {      
    } else { // format failed
        $EST_FechaCreacionRegistro='';
    }
    $html = $html.'<tr>
                    <td>'.$x.'</td>
                    <td>'.$row['ALU_Nombre'].' '.$row['ALU_ApellidoPaterno'].'</td>
                    <td>'.$row['SEX_Descripcion'].'</td>
                    <td>'.$row['ALU_Rut'].'</td>
                    <td>'.$EST_FechaCreacionRegistro.'</td>
                    <td>'.$row['TES_Descripcion'].'</td>                    
                </tr>';
};
if(!$existe){
    $html = $html.'<tr>
                <td colspan="6" style="text-align:center;">Tabla sin datos</td>
            </tr>';
};                
$html = $html.'</table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, ''); 

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Planificación</h4>
                <h5>Porcentajes horas ejecutadas y por ejecutar</h5>
                <table border="0">
                <tr>
					<th rowspan="1" scope="row"></th>
					<th>Porcentaje por ejecutar</th>
					<th>Porcentaje ejecutado</th>
					<th>Fecha de aprobación</th>
					<th>Porcentaje ejecutado real</th>
					<th>Mínimo ejecutado exigido</th>
				</tr>
                <tr>
					<th>Totales</th>';
$tsql_callSP = "spTotalHorasPorRealizaryRealizadas_Listar ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->PRY_Identificador, SQLSRV_PARAM_IN)            
    );  

$existe=false;
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    $HorasTotalesRealizadas=$row['HorasTotalesRealizadas'];
    $HorasTotalesPedagogicasRealizadas=$row['HorasTotalesPedagogicasRealizadas'];
    $PRY_HorasPedagogicasMin=$row['PRY_HorasPedagogicasMin'];
    $PorcentajeHorasPedagogicasRealizadas=$row['PorcentajeHorasPedagogicasRealizadas'];

    if($HorasTotalesRealizadas=="" or is_null($HorasTotalesRealizadas)){
        $HorasTotalesRealizadas=0;
    };
    if($HorasTotalesPedagogicasRealizadas=="" or is_null($HorasTotalesPedagogicasRealizadas)){
        $HorasTotalesPedagogicasRealizadas=0;
    };
    if($PRY_HorasPedagogicasMin=="" or is_null($PRY_HorasPedagogicasMin)){
        $PRY_HorasPedagogicasMin=0;
    };
    if(($PorcentajeHorasPedagogicasRealizadas=="" or is_null($PorcentajeHorasPedagogicasRealizadas))){
        $PorcentajeHorasPedagogicasRealizadas=0;
    };
    break;
};
if(!$existe){
    $HorasTotalesRealizadas=0;
    $HorasTotalesPedagogicasRealizadas=0;
    $PRY_HorasPedagogicasMin=0;
    $PorcentajeHorasPedagogicasRealizadas=0;
}

if($PRY_PorcentajeEjecutadoAprobado=="" or is_null($PRY_PorcentajeEjecutadoAprobado)){
    $PRY_PorcentajeEjecutadoAprobado=0;
};

if($PRY_PorcentajeEjecutadoAprobado==0 or $PorcentajeHorasPedagogicasRealizadas<$PRY_PorcentajeEjecutadoAprobado){
    $PRY_PorcentajeEjecutadoAprobado=$PorcentajeHorasPedagogicasRealizadas;
    $PRY_FechaPorcentajeEjecutado="";
};
$PorcentajeHorasPedagogicasxRealizar = 100 - $PorcentajeHorasPedagogicasRealizadas;

$PRY_FechaPorcentajeEjecutadoStr = $PRY_FechaPorcentajeEjecutado->format('Y-m-d H:i:s');
if ($PRY_FechaPorcentajeEjecutadoStr) {      
} else { // format failed
    $PRY_FechaPorcentajeEjecutadoStr='';
}
$html = $html.'<td>'.$PorcentajeHorasPedagogicasxRealizar.'%</td>
            <td>'.$PRY_PorcentajeEjecutadoAprobado.'%</td>
            <td>'.$PRY_FechaPorcentajeEjecutadoStr.'</td>
            <td>'.$PorcentajeHorasPedagogicasRealizadas.'%</td>
            <td>'.$LFO_PorcentajeMinEjecutado.'%</td>
            </tr>
        </table>
        <h4>Detalle de Planificación</h4>
        <h5>Planificación por Ejecutar</h5>
        <table border="0">
        <tr>
            <th scope="row" style="width:5%">#</th>
            <th scope="row" style="width:35%">Cursos</th> <!--Cambio Realizado por Bárbara Tematica por curso -->
            <th scope="row" style="width:20%">Metodología</th> 
            <th scope="row" style="width:20%">Relator</th> <!--Cambio Realizado por Bárbara Docente por Relator-->
            <th scope="row" style="width:20%">Fecha</th>
        </tr>';
$tsql_callSP = "spPlanificacionPorRealizar_Listar ?, ?";
$params = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->PRY_Identificador, SQLSRV_PARAM_IN)            
    );  

$existe=false;
$x=0;
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $x=$x+1;
    $existe=true;
    $html = $html.'<tr>
					<td style="width:5%">'.$x.'</td>
					<td style="width:35%">'.$row['TEM_Nombre'].'</td>
					<td style="width:20%">'.$row['MET_Descripcion'].'</td>
					<td style="width:20%">'.$row['REL_Nombres'].' '.$row['REL_Paterno'].' '.$row['REL_Materno'].'</td>
					<td style="width:20%">'.$row['PLN_Fecha'].'</td>
				</tr>';
};
if(!$existe){
    $html = $html.'<tr>
                <td colspan="5" style="text-align:center;">Tabla sin datos</td>
            </tr>';
};                
$html = $html.'</table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, ''); 

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Detalle de Planificación</h4>
                <h5>Planificación Ejecutada</h5>
                <table border="0">
                <tr>
                    <th scope="row" style="width:5%">#</th>
                    <th scope="row" style="width:35%">Cursos</th> <!--Cambio Realizado por Bárbara  Temática por Cursos-->
                    <th scope="row" style="width:20%">Metodología</th>
                    <th scope="row" style="width:20%">Relator</th> <!--Cambio Realizado por Bárbara Docentes Por-->
                    <th scope="row" style="width:20%">Fecha</th>
                </tr>';
$tsql_callSP = "spPlanificacionRealizada_Listar ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->PRY_Identificador, SQLSRV_PARAM_IN)            
);  

$existe=false;
$x=0;
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
$x=$x+1;
$existe=true;
$html = $html.'<tr>
            <td style="width:5%">'.$x.'</td>
            <td style="width:35%">'.$row['TEM_Nombre'].'</td>
            <td style="width:20%">'.$row['MET_Descripcion'].'</td>
            <td style="width:20%">'.$row['REL_Nombres'].' '.$row['REL_Paterno'].' '.$row['REL_Materno'].'</td>
            <td style="width:20%">'.$row['PLN_Fecha'].'</td>
        </tr>';
};
if(!$existe){
$html = $html.'<tr>
        <td colspan="5" style="text-align:center;">Tabla sin datos</td>
    </tr>';
};                
$html = $html.'</table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, ''); 

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Informe de Asistencia</h4>
                <h5>Estadísticas generales</h5>
                <table border="0">
                <tr>                    
                    <th scope="row" style="width:25%">N° Matriculados/as</th>
                    <th scope="row" style="width:25%">N° Beneficiarios/as con 0% asistencia</th>
                    <th scope="row" style="width:25%">N° Beneficiarios/as con 50% o más de asistencia</th>
                    <th scope="row" style="width:25%">N° Benefeciarios/as desertados/as manualmente</th>
                </tr>
                <tr>';
$tsql_callSP = "spAlumnoProyecto_TotaxlEstado ?, 0, ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->ds5_usrid, SQLSRV_PARAM_IN),
    array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
);
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe=false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    $html = $html.'<td style="width:25%">'.$row['ALU_TotalEstado'].'</td>';
};
if(!$existe){
    $html = $html.'<td style="width:25%">0</td>';
}

$tsql_callSP = "spAlumnoProyecto_TotalSinAsistencia ?, ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->ds5_usrid, SQLSRV_PARAM_IN),
    array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
);
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe=false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    $html = $html.'<td style="width:25%">'.$row['ALU_CeroAsistencia'].'</td>';
};
if(!$existe){
    $html = $html.'<td style="width:25%">0</td>';
}

$tsql_callSP = "spAlumnoProyecto_Total50oMasAsistencia ?, ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->ds5_usrid, SQLSRV_PARAM_IN),
    array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
);
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe=false;
$ALU_50maspor=0;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    if($row['PLN_PorTotalHorasAsistidas']>=50){
        $ALU_50maspor=$ALU_50maspor+1;
    };
};
if(!$existe){
    $html = $html.'<td style="width:25%">0</td>';
}else{
    $html = $html.'<td style="width:25%">'.$ALU_50maspor.'</td>';
}

$tsql_callSP = "spAlumnoProyecto_TotalDesertadosManual ?, ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->ds5_usrid, SQLSRV_PARAM_IN),
    array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
);
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe=false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    $html = $html.'<td style="width:25%">'.$row['ALU_DesetadosManual'].'</td>';
};
if(!$existe){
    $html = $html.'<td style="width:25%">0</td>';
}
$html = $html.'</tr></table>';

$html = $html.'<h5>Estadísticas por sesión</h5>
                <table border="0">
                <tr>                    
                    <th scope="row" style="width:25%">N° Sesión/as</th>
                    <th scope="row" style="width:25%">N° Alumnos/as Presentes</th>
                    <th scope="row" style="width:25%">N° Alumnos/as Ausentes</th>
                    <th scope="row" style="width:25%">N° Alumnos/as justificados/as</th>
                </tr>';
$tsql_callSP = "spAlumnoProyecto_TotalesPorSesion ?, ?, ?";
$params = array(   
    array($data->PRY_Id, SQLSRV_PARAM_IN),
    array($data->ds5_usrid, SQLSRV_PARAM_IN),
    array($data->ds5_usrtoken, SQLSRV_PARAM_IN)
);
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
$existe=false;
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))  
{
    $existe=true;
    $html = $html.'<tr><td style="width:25%">'.$row['PLN_Sesion'].'</td>';
    $html = $html.'<td style="width:25%">'.$row['ALU_Asistieron'].'</td>';
    $html = $html.'<td style="width:25%">'.$row['ALU_Ausentes'].'</td>';
    $html = $html.'<td style="width:25%">'.$row['ALU_Justificados'].'</td></tr>';

};
$html = $html.'</table>';
// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, ''); 

// ---------------------------------------------------------
//Cierre de la conexion
sqlsrv_close( $conn);


$INF_Path='d:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/informes/informeparcial/';
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