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
      //Cabecera      
      $PRY_Nombre = $row['PRY_Nombre'];
	  $LFO_Id = $row['LFO_Id'];;
      $PRY_EncargadoProyecto = $row['PRY_EncargadoProyecto'];
      $PRY_EmpresaEjecutora = $row['PRY_EmpresaEjecutora'];
      $EME_Rol = $row['EME_Rol'];
      
      $USR_NombreEjecutor = $row['USR_NombreEjecutor'];
      $USR_ApellidoEjecutor = $row['USR_ApellidoEjecutor'];
      $USR_NombreRevisor = $row['USR_NombreRevisor'];
      $USR_ApellidoRevisor = $row['USR_ApellidoRevisor'];      
      //Cabecera

      //Nivel de dimension
      $NIV_NombrePropuesto = $row['NIV_NombrePropuesto'];
      $NIV_NombreLogrado = $row['NIV_NombreLogrado'];
      $PRY_DescripcionNivel = $row['PRY_DescripcionNivel'];
      //Nivel de dimension

      //Beneficiarios
      $LIN_Hombre = $row['LIN_Hombre'];
	  $LIN_Mujer = $row['LIN_Mujer'];
      $PRY_BenDirectosHombres = $row['PRY_BenDirectosHombres'];
      $PRY_BenDirectosMujeres = $row['PRY_BenDirectosMujeres'];
      $PRY_BenDirectosTotal = $PRY_BenDirectosHombres + $PRY_BenDirectosMujeres;	
    
      $PRY_SinBenIndirectosHombres = $row['PRY_SinBenIndirectosHombres'];
      $PRY_SinBenIndirectosMujeres = $row['PRY_SinBenIndirectosMujeres'];
      $PRY_SinBenIndirectosTotal = $PRY_SinBenIndirectosHombres + $PRY_SinBenIndirectosMujeres;
    
      $PRY_EmpBenDirectosHombres = $row['PRY_EmpBenDirectosHombres'];
      $PRY_EmpBenDirectosMujeres = $row['PRY_EmpBenDirectosMujeres'];
      $PRY_EmpBenDirectosTotal = $PRY_EmpBenDirectosHombres + $PRY_EmpBenDirectosMujeres;
    
      $PRY_EmpBenIndirectosHombres = $row['PRY_EmpBenIndirectosHombres'];
      $PRY_EmpBenIndirectosMujeres = $row['PRY_EmpBenIndirectosMujeres'];
      $PRY_EmpBenIndirectosTotal = $PRY_EmpBenIndirectosHombres + $PRY_EmpBenIndirectosMujeres;
    
      $PRY_GobBenDirectosHombres = $row['PRY_GobBenDirectosHombres'];
      $PRY_GobBenDirectosMujeres = $row['PRY_GobBenDirectosMujeres'];
      $PRY_GobBenDirectosTotal = $PRY_GobBenDirectosHombres + $PRY_GobBenDirectosMujeres; 
    
      $PRY_GobBenIndirectosHombres = $row['PRY_GobBenIndirectosHombres'];
      $PRY_GobBenIndirectosMujeres = $row['PRY_GobBenIndirectosMujeres'];
      $PRY_GobBenIndirectosTotal = $PRY_GobBenIndirectosHombres + $PRY_GobBenIndirectosMujeres;
      //Beneficiarios

      //Representantes
      $PRY_TipoMesa = $row['PRY_TipoMesa'];
      //Representantes

      //Facilitadores
      $PRY_SisFacilitadores = $row['PRY_SisFacilitadores'];
      $PRY_SisObstaculizadores = $row['PRY_SisObstaculizadores'];
      //Facilitadores

      //Acuerdos/Conclusiones
      $PRY_PrincipalesAcuerdos = $row['PRY_PrincipalesAcuerdos'];
      //Acuerdos/Conclusiones

      //Desafios y continuidad
      $PRY_Desafios = $row['PRY_Desafios'];
      //Desafios y continuidad

      //Sugerencias
      $PRY_Sugerencias = $row['PRY_Sugerencias'];
      //Sugerencias

      //Tematica general y transversal
      $PRY_TematicaGeneral = $row['PRY_TematicaGeneral'];
      //Tematica general y transversal

      //Seminario de resultados
      $PRY_SeminarioResultados = $row['PRY_SeminarioResultados'];
      //Seminario de resultados
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
$pdf->SetTitle('Informe Nro.: 3 Mesas');
$pdf->SetSubject($ver);
$pdf->SetKeywords('TCPDF, PDF, mesa, dialogo, social');

// set default header data
//$pdf->SetHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
$pdf->SetHeaderData("logo_subtrab.jpg", 30, 'Informe Nro.: 3 Mesas' , $PRY_Nombre." Nro.: ".$data->PRY_Id."\nEmpresa Ejecutora: ".$PRY_EmpresaEjecutora."\nROL/RUT: ".$EME_Rol."\nEncargado del Proyecto: ".$PRY_EncargadoProyecto."\n\nSantiago ".date('d-m-o'));

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

$html = $htmlstyle.'<h4>Evaluación</h4>
            <h5>Facilitadores</h5>            
            <table  border="0">
                <tr>
                    <th scope="col">Facilitadores</th>                            
                </tr>            
                <tr>
                    <td>'.$PRY_SisFacilitadores.'</td>                           
                </tr>
            </table>                    
            <table>
                <tr>
                    <th scope="col">Obstaculizadores</th>                
                </tr>
                <tr>
                    <td>'.$PRY_SisObstaculizadores.'</td>
                </tr>
            </table>';

// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');


$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Evaluación</h4>
                <h5>Acuerdos/Conclusiones</h5>
                <table  border="0">
                    <tr>
                        <th scope="col">Principales acuerdos y/o conclusiones</th>                            
                    </tr>            
                    <tr>
                        <td>'.$PRY_PrincipalesAcuerdos.'</td>                           
                    </tr>
                </table>';

                    
// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Evaluación</h4>
                <h5>Desafíos y Continuidad</h5>
                <table  border="0">
                    <tr>
                        <th scope="col">Desafíos y continuidad</th>                            
                    </tr>            
                    <tr>
                        <td>'.$PRY_Desafios.'</td>                           
                    </tr>
                </table>';
                    
// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

$pdf->AddPage('L','A4');

$html = $htmlstyle.'<h4>Evaluación</h4>
                <h5>Sugerencias</h5>
                <table  border="0">
                    <tr>
                        <th scope="col">Sugerencias de seguimiento y monitoreo</th>                            
                    </tr>            
                    <tr>
                        <td>'.$PRY_Sugerencias.'</td>                           
                    </tr>
                </table>';
                    
// reset pointer to the last page
$pdf->lastPage();
// output the HTML content
$pdf->writeHTML($html, true, false, true, false, '');

// ---------------------------------------------------------
//Cierre de la conexion
sqlsrv_close( $conn);

//Close and output PDF document
//$pdf->Output('informecreacionescuela.pdf', 'I');

$INF_Path='d:/DocumentosSistema/dialogosocial/'.$PRY_Carpeta.'/informes/informefinal/';
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