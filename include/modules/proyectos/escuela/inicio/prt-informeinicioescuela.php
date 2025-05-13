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
      //Responsables del proyecto
      $PRY_EncargadoProyectoMail = $row['PRY_EncargadoProyectoMail'];
      $PRY_EncargadoProyectoCelular = $row['PRY_EncargadoProyectoCelular'];
      $SEX_IdEncargadoProyecto = $row['SEX_IdEncargadoProyecto'];
      $SEX_DesEncargadoProyecto = 'Otro';
      if($SEX_IdEncargadoProyecto==1){
        $SEX_DesEncargadoProyecto='Femenino';
      };
      if($SEX_IdEncargadoProyecto==2){
        $SEX_DesEncargadoProyecto='Masculino';
      };
      $PRY_EncargadoActividades = $row['PRY_EncargadoActividades'];
      $PRY_EncargadoActividadesMail = $row['PRY_EncargadoActividadesMail'];
      $PRY_EncargadoActividadesCelular = $row['PRY_EncargadoActividadesCelular'];
      $SEX_IdEncargadoActividades = $row['SEX_IdEncargadoActividades'];
      $SEX_DesEncargadoActividades = 'Otro';
      if($SEX_IdEncargadoActividades==1){
        $SEX_DesEncargadoActividades='Femenino';
      };
      if($SEX_IdEncargadoActividades==2){
        $SEX_DesEncargadoActividades='Masculino';
      };
      //Responsables del proyecto

      //Responsables de Rendición Declaración de variables(realizado por Bárbara )
      $PRY_Responsable1 = $row['PRY_Responsable1'];
      $PRY_Responsable1Mail = $row['PRY_Responsable1Mail'];
      $PRY_Responsable1Celular = $row['PRY_Responsable1Celular'];
      $SEX_IdResponsable1 = $row['SEX_IdResponsable1'];
      //$SEX_IdResponsable1 = 'Otro';
        if($SEX_IdResponsable1==1){
          $SEX_IdResponsable1='Femenino';
        };
        if($SEX_IdResponsable1==2){
          $SEX_IdResponsable1='Masculino';
        };
      $PRY_Responsable2 = $row['PRY_Responsable2'];
      $PRY_Responsable2Mail = $row['PRY_Responsable2Mail'];
      $PRY_Responsable2Celular = $row['PRY_Responsable2Celular'];
      $SEX_IdResponsable2 = $row['SEX_IdResponsable2'];
      //$SEX_IdResponsable2 = 'Otro';
        if($SEX_IdResponsable2==1){
          $SEX_IdResponsable2='Femenino';
        };
          if($SEX_IdResponsable2 == 2){
            $SEX_IdResponsable2='Masculino';
          };
      //Responsables de Rendición Final (Cambio hecho por Bárbara )
      //Planificación
      $PRY_HorasPedagogicasMinPRY=$row['PRY_HorasPedagogicasMin'];
			$PRY_PorcentajeMinOnline=$row['PRY_PorcentajeMinOnline'];
			$PRY_PorcentajeMinPresencial=$row['PRY_PorcentajeMinPresencial'];
			$MET_Id=$row['MET_Id'];
			$MET_Descripcion=$row['MET_Descripcion'];
      //Planificación
      //Actividades
      $PRY_LanzamientoFecha=$row['PRY_LanzamientoFecha'];
      $PRY_LanzamientoHora=$row['PRY_LanzamientoHora'];
      $MET_DescripcionLanzamiento=$row['MET_DescripcionLanzamiento'];
      $PRY_LanzamientoDireccion=$row['PRY_LanzamientoDireccion'];
      $PRY_ClaseCierreFecha=$row['PRY_ClaseCierreFecha'];
      $PRY_ClaseCierreHora=$row['PRY_ClaseCierreHora'];
      $MET_DescripcionCierre=$row['MET_DescripcionCierre'];
      $PRY_ClaseCierreDireccion=$row['PRY_ClaseCierreDireccion'];
      $PRY_CierreFecha=$row['PRY_CierreFecha'];
      $PRY_CierreHora=$row['PRY_CierreHora'];
      $MET_DescripcionCierre=$row['MET_DescripcionCierre'];
      $PRY_CierreDireccion=$row['PRY_CierreDireccion'];
      $PRY_UrlLanzamiento=$row['PRY_UrlLanzamiento'];
      $PRY_UrlCierre=$row['PRY_UrlCierre'];
      $PRY_UrlClaseCierre=$row['PRY_UrlClaseCierre'];
      $MET_Descripcion2=$row['MET_Descripcion2'];
      $MET_IdLanzamiento=$row['MET_IdLanzamiento'];
      $MET_IdClaseCierre=$row['MET_IdClaseCierre'];
      $MET_IdCierre=$row['MET_IdCierre'];
      //Actividades
}
sqlsrv_free_stmt( $stmt);
//print_r($PRY_Carpeta);
if($PRY_Carpeta==''){
	die('{\"response\":\"error\",\"data\":\"Carpeta no válida\":}');
};

//Grupos focales
$tsql_callSP = "spGruposFocalizacionxProyecto_Consultar ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN),		  
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
    $GRF_Id                 = $row['GRF_Id'];
    $GRF_Porcentaje 				= $row['GRF_Porcentaje'];
    $GRF_Discapacidadx				= $row['GRF_Discapacidad'];
    $GRF_AccesoInternetx 			= $row['GRF_AccesoInternet'];
    $GRF_DispositivoElectronicox 	= $row['GRF_DispositivoElectronico'];
    $GRF_PuebloOriginariox			= $row['GRF_PuebloOriginario'];
    $GRF_PerteneceSindicatox		= $row['GRF_PerteneceSindicato'];
    $GRF_PermisoSindicalx			= $row['GRF_PermisoSindical'];
    $GRF_DirigenteSindicalx			= $row['GRF_DirigenteSindical'];
    $GRF_CursoSindicalx				    = $row['GRF_CursoSindical'];
    $GRF_CargoDirectivoOrganizacionx= $row['GRF_CargoDirectivoOrganizacion'];
    break;
}
if($GRF_Discapacidadx==1){
    $GRF_Discapacidad='Si';
}else{
    $GRF_Discapacidad='No';
}
if($GRF_AccesoInternetx==1){
  $GRF_AccesoInternet='Si';
}else{
  $GRF_AccesoInternet='No';
}
if($GRF_DispositivoElectronicox==1){
  $GRF_DispositivoElectronico='Si';
}else{
  $GRF_DispositivoElectronico='No';
}
if($GRF_PuebloOriginariox==1){
  $GRF_PuebloOriginario='Si';
}else{
  $GRF_PuebloOriginario='No';
}
if($GRF_PerteneceSindicatox==1){
  $GRF_PerteneceSindicato='Si';
}else{
  $GRF_PerteneceSindicato='No';
}
if($GRF_PermisoSindicalx==1){
  $GRF_PermisoSindical='Si';
}else{
  $GRF_PermisoSindical='No';
}
if($GRF_DirigenteSindicalx==1){
  $GRF_DirigenteSindical='Si';
}else{
  $GRF_DirigenteSindical='No';
}
if($GRF_CursoSindicalx==1){
  $GRF_CursoSindical='Si';
}else{
  $GRF_CursoSindical='No';
}
if($GRF_CargoDirectivoOrganizacionx==1){
  $GRF_CargoDirectivoOrganizacion='Si';
}else{
  $GRF_CargoDirectivoOrganizacion='No';
}

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
$pdf->SetTitle('Informe Inicio Escuela');
$pdf->SetSubject($ver);
$pdf->SetKeywords('TCPDF, PDF, mesa, dialogo, social');

// set default header data
//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
$pdf->SetHeaderData("logo_subtrab.jpg", 30, 'Informe Inicio Escuela' , $PRY_Nombre." Nro.: ".$data->PRY_Id."\nEmpresa Ejecutora: ".$PRY_EmpresaEjecutora."\nROL/RUT: ".$EME_Rol."\nEncargado del Proyecto: ".$PRY_EncargadoProyecto."\n\nSantiago ".date('d-m-o'));

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

$html = $htmlstyle.'<h4>Responsables del Proyecto</h4>
                <h5>Coordinador/a de proyecto Nro 1</h5>
                <table border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_EncargadoProyecto.'</td>
                    <td width="50%">'.$PRY_EncargadoProyectoMail.'</td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_EncargadoProyectoCelular.'</td>
                    <td width="50%">'.$SEX_DesEncargadoProyecto.'</td>
                  </tr>
                </table>               
                <h5>Coordinador/a de proyecto Nro 2</h5>
				        <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_EncargadoActividades.'</td>
                    <td width="50%">'.$PRY_EncargadoActividadesMail.'</td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_EncargadoActividadesCelular.'</td>
                    <td width="50%">'.$SEX_DesEncargadoActividades.'</td> 
                  </tr>
                </table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

//Responsables de Rendicion Cambio Hecho por Barbara 
$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Responsables de Rendición </h4>
                <h5>Coordinador/a de proyecto Nro 1</h5>
                <table border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_Responsable1.'</td>
                    <td width="50%">'.$PRY_Responsable1Mail.'</td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_Responsable1Celular.'</td>
                    <td width="50%">'.$SEX_IdResponsable1.'</td>
                  </tr>
                </table>               
                <h5>Coordinador/a de proyecto Nro 2</h5>
				        <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Nombre</th>
                    <th scope="col" width="50%">Correo electrónico</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_Responsable2.'</td>
                    <td width="50%">'.$PRY_Responsable2Mail.'</td>
                  </tr>
                </table>
                <table  border="0">
                  <tr>
                    <th scope="col" width="50%">Teléfono</th>
                    <th scope="col" width="50%">Sexo</th>
                  </tr>
                  <tr>
                    <td width="50%">'.$PRY_Responsable2Celular.'</td>
                    <td width="50%">'.$SEX_IdResponsable2.'</td> <!--El sexo no se muestra en el informe -- SOLUCIONADO-->
                  </tr>
                </table>';
                

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');
//Termino de Responsables de Rendición

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Focalización de Beneficiarios</h4>
                <h5>Grupos Focales</h5>
                <table border="0">
                  <tr>
                    <th>Discapacidad</th>
                    <th>Acceso a Internet</th>
                    <th>Pueblo Originario</th>
                    <th>Pertenece Sindicato</th>                    
                  </tr>
                  <tr>
                    <td>'.$GRF_Discapacidad.'</td>
                    <td>'.$GRF_AccesoInternet.'</td>                    
                    <td>'.$GRF_PuebloOriginario.'</td>
                    <td>'.$GRF_PerteneceSindicato.'</td>                    
                  </tr>
                </table>
                <table border="0">
                  <tr>
                    <th>Permiso Sindical</th>
                    <th>Dirigente Sindical</th>
                    <th>Curso sindical</th>
                    <th>Curso sindical</th>
                  </tr>
                  <tr>
                    <td>'.$GRF_PermisoSindical.'</td>
                    <td>'.$GRF_DirigenteSindical.'</td>
                    <td>'.$GRF_CursoSindical.'</td>
                    <td>'.$GRF_CargoDirectivoOrganizacion.'</td>                    
                  </tr>
                </table>
                <h5>Grupos incorporados (multiselección)</h5>
                <table border="0">
                  <tr>
                    <th>Id</th>
                    <th>Nacionalidad</th>
                    <th>Sexo</th>
                    <th>Educación</th>
                    <th>Discapacidad</th>
                    <th>Rubro</th>
                    <th>Trabajador</th>
                    <th>Tramo Etario</th>
                  </tr>';

//Grupos focales, multiselección
$tsql_callSP = "spGruposFocalizacionMultiseleccion_Listar ?";
$params = array(   
		  array($GRF_Id, SQLSRV_PARAM_IN)
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
    $html = $html.'<tr>
                <td>'.$row['GFM_Id'].'</td>
                <td>'.$row['NAC_Nombre'].'</td>
                <td>'.$row['SEX_Descripcion'].'</td>
                <td>'.$row['EDU_Nombre'].'</td>
                <td>'.$row['TDI_Nombre'].'</td>
                <td>'.$row['RUB_Nombre'].'</td>
                <td>'.$row['TTR_Nombre'].'</td>
                <td>'.$row['TRE_Descripcion'].'</td>
              </tr>';
}
$html = $html.'</table>
              <h5>Porcentaje de alumnos que cumplen los filtros</h5>
              <table border="0">
                <tr>
                  <th>Total Filtrado</th>
                  <th>Total Alumnos</th>
                  <th>Porcentaje mínimo exigido</th>
                  <th>Porcentaje filtrado</th>
                </tr>';

//Porcentaje de alumnos que cumplen los filtros
$tsql_callSP = "spGruposFocalesconFiltros2016_Listar ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN)
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
    $html = $html.'<tr>
                  <td>'.$row['TotalAlumnosFiltrados'].'</td>
                  <td>'.$row['TotalAlumnos'].'</td>
                  <td>'.$row['PorcentajeMax'].'</td>
                  <td>'.round(($row['TotalAlumnosFiltrados']*100)/$row['TotalAlumnos'],0).'</td>
                </tr>';
    break;
}
$html = $html.'</table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Estadísticas</h4>
                <h4>Postulaciones</h4>
                <h5>Cantidad de matriculados</h5>
                <table border="0">
                  <tr>
                    <th>Total Hombres</th>
                    <th>% de Hombres</th>
                    <th>Total Mujeres</th>
                    <th>% de Mujeres</th>
                    <th>Total</th>
                  </tr>
                </table>';

//Postulaciones
$TotalInscri=0;
$PRY_CantInscriMujer=0;
$PRY_CantInscriHombre=0;
$PRY_CantidadDiscapacidad=0;
$PRY_PorInscriHombre=0;
$PRY_CantidadExtranjeros=0;
$PRY_PorExtranjeros=0;
$PRY_PorDiscapacidad=0;
$PRY_Tramo1825=0;
$PRY_Tramo2635=0;
$PRY_Tramo3645=0;
$PRY_Tramo4655=0;
$PRY_Tramo5665=0;
$PRY_Tramo66mas=0;		
$PRY_PorTramo1825=0;
$PRY_PorTramo2635=0;
$PRY_PorTramo3645=0;
$PRY_PorTramo4655=0;
$PRY_PorTramo5665=0;
$PRY_PorTramo66mas=0;
$PRY_CantidadDirigente=0;
$PRY_PorDirigente=0;

$tsql_callSP = "spAlumnoProyectoPostulacion_Listar ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN)
   );  

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
    $TotalInscri=$TotalInscri+1;
    if($row['SEX_Id']==1){
				$PRY_CantInscriMujer=$PRY_CantInscriMujer+1;
    }else{
		    $PRY_CantInscriHombre=$PRY_CantInscriHombre+1;
		};
		if($row['NAC_Id']!=1){
				$PRY_CantidadExtranjeros=$PRY_CantidadExtranjeros+1;
    };
		if($row['TDI_Id']!=""){
		    $PRY_CantidadDiscapacidad=$PRY_CantidadDiscapacidad+1;
    };		
    if($row['Edad']>=18 and $row['Edad']<=25){
      $PRY_Tramo1825=$PRY_Tramo1825+1;
    };
    if($row['Edad']>=26 and $row['Edad']<=35){
      $PRY_Tramo2635=$PRY_Tramo2635+1;
    };
    if($row['Edad']>=36 and $row['Edad']<=45){
      $PRY_Tramo3645=$PRY_Tramo3645+1;
    };
    if($row['Edad']>=46 and $row['Edad']<=55){
      $PRY_Tramo4655=$PRY_Tramo4655+1;
    };
    if($row['Edad']>=56 and $row['Edad']<=65){
      $PRY_Tramo5665=$PRY_Tramo5665+1;
    };
    if($row['Edad']>=66){
      $PRY_Tramo66mas=$PRY_Tramo66mas+1;
    };
    if($row['ALU_DirigenteSindical']==1){
      $PRY_CantidadDirigente=$PRY_CantidadDirigente+1;
    };    
};
$PRY_PorInscriHombre=($PRY_CantInscriHombre*100)/$TotalInscri;
if(($PRY_PorInscriHombre<100) and ($PRY_PorInscriHombre>0)){
  $PRY_PorInscriHombre=number_format($PRY_PorInscriHombre,2);
};
$PRY_PorInscriMujer=($PRY_CantInscriMujer*100)/$TotalInscri;
if(($PRY_PorInscriMujer<100) and ($PRY_PorInscriMujer>0)){
  $PRY_PorInscriMujer=number_format($PRY_PorInscriMujer);
};
$PRY_PorExtranjeros=($PRY_CantidadExtranjeros*100)/$TotalInscri;
if(($PRY_PorExtranjeros<100) and ($PRY_PorExtranjeros>0)){
  $PRY_PorExtranjeros=number_format($PRY_PorExtranjeros);
};		
$PRY_PorDiscapacidad=($PRY_CantidadDiscapacidad*100)/$TotalInscri;
if(($PRY_PorDiscapacidad<100) and ($PRY_PorDiscapacidad>0)){
  $PRY_PorDiscapacidad=number_format($PRY_PorDiscapacidad);
};		
$PRY_PorTramo1825=($PRY_Tramo1825*100)/$TotalInscri;
if(($PRY_PorTramo1825<100) and ($PRY_PorTramo1825>0)){
  $PRY_PorTramo1825=number_format($PRY_PorTramo1825,2);
};
$PRY_PorTramo2635=($PRY_Tramo2635*100)/$TotalInscri;
if(($PRY_PorTramo2635<100) and ($PRY_PorTramo2635>0)){
  $PRY_PorTramo2635=number_format($PRY_PorTramo2635,2);
};		
$PRY_PorTramo3645=($PRY_Tramo3645*100)/$TotalInscri;
if(($PRY_PorTramo3645<100) and ($PRY_PorTramo3645>0)){
  $PRY_PorTramo3645=number_format($PRY_PorTramo3645,2);
};		
$PRY_PorTramo4655=($PRY_Tramo4655*100)/$TotalInscri;
if(($PRY_PorTramo4655<100) and ($PRY_PorTramo4655>0)){
  $PRY_PorTramo4655=number_format($PRY_PorTramo4655,2);
};		
$PRY_PorTramo5665=($PRY_Tramo5665*100)/$TotalInscri;
if(($PRY_PorTramo5665<100) and ($PRY_PorTramo5665>0)){
  $PRY_PorTramo5665=number_format($PRY_PorTramo5665,2);
};		
$PRY_PorTramo66mas=($PRY_Tramo66mas*100)/$TotalInscri;
if(($PRY_PorTramo66mas<100) and ($PRY_PorTramo66mas>0)){
  $PRY_PorTramo66mas=number_format($PRY_PorTramo66mas,2);
};	
$PRY_PorDirigente=($PRY_CantidadDirigente*100)/$TotalInscri;
if(($PRY_PorDirigente<100) and ($PRY_PorDirigente>0)){
  $PRY_PorDirigente=number_format($PRY_PorDirigente,2);
};

if($TotalAlumnos==""){
  $TotalAlumnos=$TotalInscri;
};
$PorcentajeFil = round(($TotalAlumnosFiltrados*100)/$TotalAlumnos,0);
$html = $html.'<tr>
                <td>'.$PRY_CantInscriHombre.'</td>
                <td>'.$PRY_PorInscriHombre.'</td>
                <td>'.$PRY_CantInscriMujer.'</td>
                <td>'.$PRY_PorInscriMujer.'</td>
                <td>'.$TotalInscri.'</td>
              </tr>
            </table>
            <h5>Cantidad de extranjeros/as</h5>
                <table border="0">
                  <tr>
                    <th>Total de extranjeros/as</th>
                    <th>% de extranjeros/as</th>
                  </tr>
                  <tr>
                    <td>'.$PRY_CantidadExtranjeros.'</td>
                    <td>'.$PRY_PorExtranjeros.'</td>
                  </tr>
                </table>
            <h5>Cantidad de discapacitados/as</h5>
                <table border="0">
                  <tr>
                    <th>Total de discapacitados/as</th>
                    <th>% de de discapacitados/as</th>
                  </tr>
                  <tr>
                    <td>'.$PRY_CantidadDiscapacidad.'</td>
                    <td>'.$PRY_PorDiscapacidad.'</td>
                  </tr>
                </table>
            <h5>Cantidad por tramo etário</h5>
                <table border="0">
                  <tr>
                    <th>Total 18-25</th>
                    <th>%</th>
                    <th>Total 26-35</th>
                    <th>%</th>
                    <th>Total 36-45</th>
                    <th>%</th>
                  </tr>
                  <tr>
                    <td>'.$PRY_Tramo1825.'</td>
                    <td>'.$PRY_PorTramo1825.'</td>
                    <td>'.$PRY_Tramo2635.'</td>
                    <td>'.$PRY_PorTramo2635.'</td>
                    <td>'.$PRY_Tramo3645.'</td>
                    <td>'.$PRY_PorTramo3645.'</td>
                  </tr>
                </table>
                <table border="0">
                  <tr>
                    <th>Total 46-55</th>
                    <th>%</th>
                    <th>Total 56-65</th>
                    <th>%</th>
                    <th>Total 66 y más</th>
                    <th>%</th>
                  </tr>
                  <tr>
                    <td>'.$PRY_Tramo4655.'</td>
                    <td>'.$PRY_PorTramo4655.'</td>
                    <td>'.$PRY_Tramo5665.'</td>
                    <td>'.$PRY_PorTramo5665.'</td>
                    <td>'.$PRY_Tramo66mas.'</td>
                    <td>'.$PRY_PorTramo66mas.'</td>
                  </tr>
                </table>
            <h5>Cantidad de dirigentes/as sindicales</h5>
                <table border="0">
                  <tr>
                    <th>Total de dirigentes/as</th>
                    <th>% de de dirigentes/as</th>
                  </tr>
                  <tr>
                    <td>'.$PRY_CantidadDirigente.'</td>
                    <td>'.$PRY_PorDirigente.'</td>
                  </tr>
                </table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$tsql_callSP = "spPlanificacionPlantillaCreacion_Listar ?";
$params = array(   
		  array($LIN_Id, SQLSRV_PARAM_IN)
   );  

$PRY_HorasPedagogicasMinTEM=0;
$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
  $PRY_HorasPedagogicasMinTEM=$PRY_HorasPedagogicasMinTEM+$row['TEM_Horas'];
}
$TotalModulos=0;
$TotalPerspectivas=0;
$TotalTematicas=0;
$ModuloHoras=0;
$FechaInicio='';
$FechaFin='';	
$Horas_Pedagogicas=0;

$tsql_callSP = "spPlanificacionResumenMetodologia_Listar ?, ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN),
      array($data->PRY_Identificador, SQLSRV_PARAM_IN)
   );

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
  $TotalModulos=$row['ModuloCant'];
  $TotalPerspectivas=$row['PerspectivasCant'];
  $TotalTematicas=$row['TematicasCant'];
  $ModuloHoras=$row['ModuloHoras'];
  $FechaInicio=$row['FechaInicio'];
  $FechaFin=$row['FechaFin'];		
  $Horas_Pedagogicas=$row['Horas_Pedagogicas'];
  break;
}

if(is_null($ModuloHoras)){
  $ModuloHoras=0;
};
if(is_null($Horas_Pedagogicas)){
  $Horas_Pedagogicas=0;
};
if(is_null($FechaInicio)){
  $FechaInicio="Sin inicio";
};
if(is_null($FechaFin)){
  $FechaFin="Sin fin";
};

$tsql_callSP = "spPlanificacionSesiones_Total ?, ?";
$params = array(   
		  array($data->PRY_Id, SQLSRV_PARAM_IN),
      array($data->PRY_Identificador, SQLSRV_PARAM_IN)
   );

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
  $TotalPlantilla=$row['TotalPlantilla'];
	$TotalPlanificado=$row['TotalPlanificado'];
  break;
}

$TotalHoras=0;
$TotalHorasPedagogica=0;
$TotalPorMin = 0;
$TotalPorHoras = 0;
$salir = false;
$imprimir = false;

$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Planificación</h4>                
                <h5>Resumen general de la plnificación</h5>
                <table border="0">
                  <tr>
                    <th></th>
                    <th>Cursos</th>
                    <th>Perspectiva</th>
                    <th>Cursos y Dimensiones ('.$TotalPlantilla.')</th>
                    <th>Total horas</th>
                    <th>Horas Pedagógicas ('.$PRY_HorasPedagogicasMinTEM.')</th>
                    <th>Fecha inicio</th>
                    <th>Fecha término</th>
                  </tr>
                  <tr>
                    <th>Totales</th>
                    <td>'.$TotalModulos.'</td>
                    <td>'.$TotalPerspectivas.'</td>
                    <td>'.$TotalTematicas.'</td>
                    <td>'.$ModuloHoras.'</td>
                    <td>'.$Horas_Pedagogicas.'</td>
                    <td>'.$FechaInicio.'</td>
                    <td>'.$FechaFin.'</td>
                  </tr>
                </table>';
$html = $html.'<h4>Metodología: '.$MET_Descripcion.'</h4>                
                <h5>Segregación de horas pedagógicas por tipo de metodología</h5>
                <table border="0">
                  <tr>
                    <th>Metodología</th>
                    <th>Total Horas</th>
                    <th>Total Horas Pedagógicas</th>
                    <th>% Horas Pedagógicas</th>
                    <th>% Mínimo Exigido</th>
                  </tr>';

$tsql_callSP = "spPlanificacionResumenMetodologia_Listar ?, ?";
$params = array(   
      array($data->PRY_Id, SQLSRV_PARAM_IN),
      array($data->PRY_Identificador, SQLSRV_PARAM_IN)
    );

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{ 
  $PorMin = 0;
	if($MET_Id==3){
	  if($row['MET_Id']==1){
		  $PorMin = $PRY_PorcentajeMinOnline;
    };
		if($row['MET_Id']==2){
			$PorMin = $PRY_PorcentajeMinPresencial;
    };
		$salir = false;
		$imprimir = true;
  }else{
	  if($MET_Id==1){
			if($row['MET_Id']==1){
			  $PorMin = $PRY_PorcentajeMinOnline;
				$salir = true;
				$imprimir = true;
      }else{
			  $imprimir = false;
      };				
		};
		if($MET_Id==2){
		  if($row['MET_Id']==2){
			  $PorMin = $PRY_PorcentajeMinPresencial;        
				$salir = true;
				$imprimir = true;
      }else{
			  $imprimir = false;
      };				
    };
  };
	if($imprimir){	  
	  $html = $html.'<tr>
		  <th>'.$row['MET_Descripcion'].'</th>
			<td>'.round($row['TotalHorasMET'],1).'</td>
			<td>'.round($row['TotalHorasPedagogicasMET'],1).'</td>
			<td>';
        if($PRY_HorasPedagogicasMinTEM>0){
          $html = $html.round(($row['TotalHorasPedagogicasMET']/$PRY_HorasPedagogicasMinTEM)*100).'%</td>';
        }else{
          $html = $html.'0%</td>';
        }
        $html = $html.'<td>'.$PorMin.'%</td>
			</tr>';
  };
  $TotalHoras = $TotalHoras + round($row['TotalHorasMET'],1);
  $TotalHorasPedagogica = $TotalHorasPedagogica + round($row['TotalHorasPedagogicasMET'],1);
  $TotalPorMin = $TotalPorMin + round($PorMin,1);
  if($PRY_HorasPedagogicasMinTEM>0){
    $TotalPorHoras = round($TotalPorHoras + round(($row['TotalHorasPedagogicasMET']/$PRY_HorasPedagogicasMinTEM)*100),1);
  }else{
    $TotalPorHoras = round($TotalPorHoras,1);
  };
  if($salir){
    break;
	};
};
if($MET_Id==3){
  $html = $html.'<tr>
    <th>Totales</th>
    <td>'.$TotalHoras.'</td>
    <td>'.$TotalHorasPedagogica.'</td>
    <td>'.$TotalPorHoras.'%</td>
    <td>'.$TotalPorMin.'%</td>
  </tr>';
};
$html = $html.'</table>';
// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');

$MOD_Id=0;
$PER_Id=0;
$TEM_Id=0;
$corr=0;
$sw=0;
$TemPen = 0;

$html = $htmlstyle;
$tsql_callSP = "spPlanificacionPlantilla_Listar ?, ?";
$params = array(   
      array($data->PRY_Id, SQLSRV_PARAM_IN),
      array($data->PRY_Identificador, SQLSRV_PARAM_IN)
    );

$stmt = sqlsrv_query( $conn, $tsql_callSP, $params);
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
{
  //Módulos
  if($MOD_Id!=$row['MOD_Id']){
    if($MOD_Id!=0){      
      $html = $html.'</tr>
                </table>';
      $pdf->lastPage();

      // output the HTML content
      $pdf->writeHTML($html, true, false, true, false, '');
      
      $pdf->AddPage('L','A4');
      $html = $htmlstyle;
    };
    
    $html = $html.'<h4>Detalle de Planificación</h4>
                  <h5>'.$row['MOD_Nombre'].'</h5>    
                  <table border="0">
                    <tr>
                      <th>Perspectiva</th>
                      <th>Módulo</th>
                      <th>Metodología</th>
                      <th>Minutos Panificados</th>
                      <th>Max H.Ped. (M.Reales)</th>
                      <th>Diferencia</th>
                    </tr>
                    <tr>';

  
  };
  //Perspectiva
  $tr=0;
  if($PER_Id!=$row['PER_Id']){
	  if($PER_Id!=0){
		  $sw=1;
      $tr=1;
			$html = $html.'</tr>
							<tr data-tr="0">';      
    };
		if($row['TematicaProyecto']==1){
      $tsql_callSP2 = "spTematicaProyectoPlanificacion_Listar ?, ?, ?";
      $params2 = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),
            array($data->PRY_Identificador, SQLSRV_PARAM_IN),
            array($row['PER_Id'], SQLSRV_PARAM_IN)
          );
    }else{
      $tsql_callSP2 = "spTematicaPlanificacion_Listar ?, ?, 1";
      $params2 = array(   
            array($data->PRY_Id, SQLSRV_PARAM_IN),            
            array($row['PER_Id'], SQLSRV_PARAM_IN)
          );
    };
    $TEM_Tot=0;
    $stmt2 = sqlsrv_query( $conn, $tsql_callSP2, $params2);
    while( $row2 = sqlsrv_fetch_array( $stmt2, SQLSRV_FETCH_ASSOC))
    {		
		  $TEM_Tot=$TEM_Tot+1;
    };					
		if($TEM_Tot==0){
		  $TEM_Tot=1;
    };
    $html = $html.'<th rowspan="'.$TEM_Tot.'" scope="row" data-th="0">'.$row['PER_Nombre'].'</th>';
  };
  $tsql_callSP3 = "spTotalHorasTematicaMetodologia_Calcular ?, ?, ?, ?, ?";
  $params3 = array(
        array($row['TEM_Id'], SQLSRV_PARAM_IN),
        array($data->PRY_Id, SQLSRV_PARAM_IN),
        array($data->PRY_Identificador, SQLSRV_PARAM_IN),
        array($data->ds5_usrid, SQLSRV_PARAM_IN),
        array($data->ds5_usrtoken, SQLSRV_PARAM_IN)        
      );
    
  $Diferencia=round(($row['TEM_Horas']*45),2) * -1;
  $TotalMinutosPlanificados=0;
  $TotalMinutosTematica=0;
  $existe=false;

  $sesion=1;
  $Diferencia=0;
  $TotalMinutosPlanificados=0;
  $final=false;
  $MET_Id=0;
  $existe=false;

  $stmt3 = sqlsrv_query( $conn, $tsql_callSP3, $params3);
  while( $row3 = sqlsrv_fetch_array( $stmt3, SQLSRV_FETCH_ASSOC))
  {
    $TotalMinutosPlanificados=$TotalMinutosPlanificados+$row3['TotalMinutosPlanificados'];
    $TotalMinutosTematica=$row3['TotalMinutosTematica'];
    $imprime=false;
    $existe=true;
    $sw=0;    
    if($TEM_Id!=$row['TEM_Id']){
      $sw=1;
      if($MET_Id!=$row3['MET_Id'] and $MET_Id!=0){
        $sw=3;
        $html = $html.'</tr>
                  <tr data-tr="1">';
      };
      if($TEM_Id!=0 and $PER_Id=$row['PER_Id'] and $sw!=3 and $tr!=1){
        $sw=2;
        $html = $html.'</tr>
                    <tr data-tr="2">';
      };
      $imprime=true;
    };	
    $Diferencia = $TotalMinutosPlanificados-$TotalMinutosTematica;
    if($imprime){
      $html = $html.'<th rowspan="'.$sesion.'" scope="row" data-th="1">'.$row['TEM_Nombre'].'</th>';
    };
    $html = $html.'<td>'.$row3['MET_Descripcion'].'</td>
                  <td>'.$TotalMinutosPlanificados.'</td>
                  <td>'.$TotalMinutosTematica.'</td>
                  <td>'.$Diferencia.'</td>';
    $MET_Id=$row3['MET_Id'];
  };
  if(!$existe){    
    $sesion=1;
    $TemPen = $TemPen + 1;
    if($TEM_Id!=$row['TEM_Id']){
      if($TEM_Id!=0 and $PER_Id==$row['PER_Id']){
        $html = $html.'</tr>
                  <tr data-tr="3">';
      };
      $html = $html.'<th rowspan="'.$sesion.'" scope="row" data-th="2">'.$row['TEM_Nombre'].'</th>';
    };
    $html = $html.'<td>'.$MET_Descripcion.'</td>
                <td>'.$TotalMinutosPlanificados.'</td>
                <td>'.$TotalMinutosTematica.'</td>
                <td>'.$Diferencia.'</td>';
  }



  $MOD_Id=$row['MOD_Id'];
  $PER_Id=$row['PER_Id'];
  $TEM_Id=$row['TEM_Id'];
  $corr=$corr+1;
};
$html = $html.'</tr>
            </table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

//Actividades
$pdf->AddPage('L','A4');
$html = $htmlstyle.'<h4>Actividades</h4>                
                <h5>Ceremonia de Inicio y prueba de diagnóstico</h5>
                <table border="0">
                  <tr>
                    <th>Fecha de lanzamiento</th>
                    <th>Hora de lanzamiento</th>
                    <th>Metodología</th>';
                    if($MET_IdLanzamiento==2 or $MET_IdLanzamiento==3){
                      $html=$html.'<th>Dirección lanzamiento</th>';
                    };
                    if($MET_IdLanzamiento==1 or $MET_IdLanzamiento==3){
                      $html=$html.'<th>Url lanzamiento</th>';
                    };
                    $html=$html.'</tr>
                  <tr>
                    <td>'.$PRY_LanzamientoFecha.'</td>
                    <td>'.$PRY_LanzamientoHora.'</td>
                    <td>'.$MET_DescripcionLanzamiento.'</td>';
                    if($MET_IdLanzamiento==2 or $MET_IdLanzamiento==3){
                      $html=$html.'<td>'.$PRY_LanzamientoDireccion.'</td>';
                    };
                    if($MET_IdLanzamiento==1 or $MET_IdLanzamiento==3){
                      $html=$html.'<td>'.$PRY_UrlLanzamiento.'</td>';
                    };
                    $html=$html.'</tr>
                </table>
                <h5>Clase de cierre y evaluación final</h5>
                <table border="0">
                  <tr>
                    <th>Fecha de cierre</th>
                    <th>Hora de cierre</th>
                    <th>Metodología</th>';
                    if($MET_IdClaseCierre==2 or $MET_IdClaseCierre==3){
                      $html=$html.'<th>Dirección lanzamiento</th>';
                    };
                    if($MET_IdClaseCierre===1 or $MET_IdClaseCierre===3){
                      $html=$html.'<th>Url ceremonia</th>';
                    }
                    $html=$html.'</tr>                
                  <tr>
                    <td>'.$PRY_ClaseCierreFecha.'</td>
                    <td>'.$PRY_ClaseCierreHora.'</td>
                    <td>'.$MET_Descripcion2.'</td>';
                    if($MET_IdClaseCierre==2 or $MET_IdClaseCierre==3){
                      $html=$html.'<td>'.$PRY_ClaseCierreDireccion.'</td>';
                    };
                    if($MET_IdClaseCierre==1 or $MET_IdClaseCierre==3){
                      $html=$html.'<td>'.$PRY_UrlClaseCierre.'</td>';
                    };
                    $html=$html.'</tr>
                </table>
                <h5>Panel y ceremonia de certificación</h5>
                <table border="0">
                  <tr>
                    <th>Fecha de cereminia</th>
                    <th>Hora de ceremonia</th>
                    <th>Metodología</th>';
                    if($MET_IdCierre==2 or $MET_IdCierre==3){
                      $html=$html.'<th>Dirección ceremonia</th>';
                    };
                    if($MET_IdCierre==1 or $MET_IdCierre==3){
                      $html=$html.'<th>Url ceremonia</th>';
                    };
                    $html=$html.'</tr>
                  <tr>
                    <td>'.$PRY_CierreFecha.'</td>
                    <td>'.$PRY_CierreHora.'</td>
                    <td>'.$MET_DescripcionCierre.'</td>';
                    if($MET_IdCierre==2 or $MET_IdCierre==3){
                      $html=$html.'<td>'.$PRY_CierreDireccion.'</td>';
                    };
                    if($MET_IdCierre==1 or $MET_IdCierre==3){
                      $html=$html.'<td>'.$PRY_UrlCierre.'</td>';
                    };
                    $html=$html.'</tr>
                </table>';

// reset pointer to the last page
$pdf->lastPage();

// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');                    

// ---------------------------------------------------------
//Cierre de la conexion
sqlsrv_close( $conn);


$INF_Path='d:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/informes/informeinicio/';
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