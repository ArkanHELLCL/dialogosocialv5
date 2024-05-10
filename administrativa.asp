<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE FILE="include\template\session.min.inc" -->
<%response.write("200/@/")
	'url_mesa="/requerimiento-usuario-html-fondo-mesa"
	'url_escuela="/requerimiento-usuario-html-fondo-escuela"
		
	tpo=request("tpo")
	if(tpo="") then
		tpo=1
	end if
	titulo="Lista de Proyectos"
	gradiente="aqua-gradient"
	PRY_Estado=1
	url_fondoescuela="/tbl-administrativa"
	color="darkblue-text"
	
	if tpo=1 then
		FON_Id=1
		url="/bandeja-administrativa/modificar"				
	end if
	if(tpo=2) then	
		FON_Id=2
		url="/bandeja-ejecucion-presupuestaria/modificar"
	end if		
%>
<div class="row container-header">

</div>
<div class="row container-body mCustomScrollbar">
	<!--container-nav-->
	<div class="container-nav">
		<div class="header">				
			<div class="content-nav"><%				
				set cnn = Server.CreateObject("ADODB.Connection")
				on error resume next	
				cnn.open session("DSN_DialogoSocialv5")
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Conexión:" & ErrMsg)
				   response.End() 			   
				end if			
				
				sql="exec spFondos_Listar 1"				
				set rs = cnn.Execute(sql)
				if cnn.Errors.Count > 0 then 
				   ErrMsg = cnn.Errors(0).description	   
				   cnn.close
				   response.Write("503/@/Error Ejecucion:" & ErrMsg)
				   response.End() 			   
				end if
				cont=1				
				do while not rs.eof
					if cont=1 then
						active="active"
					else
						active=""
					end if%>
					<a id="tab<%=rs("FON_Id")%>-tab" href="#tab<%=rs("FON_Id")%>" class="<%=active%> tab" data-fon="<%=rs("FON_Id")%>"><i class="fas fa-book"></i> <%=UCAse(rs("FON_Nombre"))%></a><%
					rs.movenext
				loop%>
				<span class="yellow-bar"></span>
				<button type="button" class="close text-primary text-white" aria-label="Close" data-url="/bandeja-administrativa">
					<span aria-hidden="true">×</span>
				</button>
				<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
					<div class="animated-icon1"><span></span><span></span><span></span></div>
				</button>
			</div>				
		</div>
	
		<!--tab-content-->
		<div class="tab-content">
			<!--tab1-->
			<div id="tab1" data-fon="1">

				<!--wrapper-editor-->
				<div class="wrapper-editor">					
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
						<!-- Table with panel -->					
						<div class="card card-cascade narrower">
							<!--Card image-->
							<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
								<div>
								</div>
								<a href="" class="mx-3 <%=color%>"><i class="fas fa-book"></i> <%=titulo%></a>
								<div>
									<button class="btn btn-secondary btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="fondoescuela">Exportar<i class="fas fa-download ml-1"></i></button>
								</div>
							</div>
							<!--/Card image-->
							<div class="px-4">
								<div class="table-wrapper col-sm-12 mCustomScrollbar" id="container-table-1">
								<!--Table-->
									<table id="tbl-fondoescuela" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="fondoescuela">
										<thead>
											<tr>								
												<th>#</th>
												<th>Empresa Ejecutora</th>
												<th>P.M.</th>
												<th>P.A.</th>
												<th>#</th>
												<th>L.Formativa</th>
												<th>#</th>
												<th>Línea</th>
												<th>L.M.</th>
												<th>Reg.</th>
												<!--10-->
												<th>Contraparete Técnica</th>
												<th>N° Res. Aprueba Contrato</th>
												<th>Fecha Res. Contrato</th>
												<th>Año</th>
												<th>Inicio</th>
												<th>Estado Inf.n°1</th>
												<th>Fecha Pago cuota n°1</th>
												<th>Informe Inicio Fecha Aceptado</th>
												<th></th>
												<th>Estado Inf.n°2</th>
												<!--20-->
												<th>Fecha Pago cuota n°2</th>
												<th>Informe  Fecha Aceptado</th>
												<th>Final</th>
												<th>Estado Inf.n°3</th>
												<th>Fecha Pago cuota n°3</th>
												<th>Ceremonia de Cierre</th>	
												<th>Informe Final Fecha Aceptado</th>	
												<th>Hito</th>
												<th>Estado</th>
												<th>Región</th>
												<!--30-->
												<th>Comuna</th>												
												<th>Nombre Revisor</th>
												<th>Apellido Revisor</th>												
												<th>Mail Revisor</th>												
												<th>Telefono Revisor</th>
												<th>Direccion Revisor</th>							
												<th>Nombre Ejecutor</th>
												<th>Apellido Ejecutor</th>
												<th>Mail Ejecutor</th>
												<th>Telefono Ejecutor</th>
												<!--40-->
												<th>Direccion Ejecutor</th>												
												<th>Nombre Institucion Ejecutor</th>
												<th>Sexo Ejecutor</th>												
												<th>Encargado Proyecto Mail</th>												
												<th>Encargado Proyecto Celular</th>
												<th>Sexo Encargado Proyecto</th>
												<th>Encargado Actividades</th>
												<th>Encargado Actividades Mail</th>
												<th>Encargado Actividades Celular</th>
												<th>Sexo Encargado Actividades</th>
												<!--50-->
												<th>Informe Inicio FechaEnvio</th>																
												<th>Informe Final Fecha Envio</th>
												<th>Creacion Proyecto Fecha Envio</th>													
												<th>Informe Inicio Aceptado</th>												
												<th>Informe  Aceptado</th>	
												<th>Informe Final Aceptado</th>													
												<th>Direccion de Lanzamiento</th>			
												<th>Fecha de Lanzamiento</th>	
												<th>Hora de Lanzamiento</th>			
												<th>Direccion de Cierre</th>												
												<!--60-->
												<th>Hora de Cierre</th>
												<th>Dias para vencimiento Inf.Inicial</th>												
												<th>Dias para vencimiento Inf.</th>												
												<th>Dias para vencimiento Inf.Final</th>
												<th>%Avance</th>
												<th>%Retraso</th>
												<th>Avance Ejecución Presupuestaria</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>

								</div>
							</div>
						</div>
						<!-- Table with panel -->		
					</div>	  
				</div>
				<!--wrapper-editor-->

			</div>
			<!--tab1-->
			<!--tab2-->
			<div id="tab2" data-fon="2">

				<!--wrapper-editor-->
				<div class="wrapper-editor">					
					<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">						
						<!-- Table with panel -->					
						<div class="card card-cascade narrower">
							<!--Card image-->
							<div class="view view-cascade gradient-card-header <%=gradiente%> narrower py-2 mx-4 mb-3 d-flex justify-content-between align-items-center">
								<div>
								</div>
								<a href="" class="mx-3 <%=color%>"><i class="fas fa-book"></i> <%=titulo%></a>
								<div>
									<button class="btn btn-default btn-rounded buttonExport btn-sm waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="fondomesa">Exportar<i class="fas fa-download ml-1"></i></button>
								</div>
							</div>
							<!--/Card image-->
							<div class="px-4">
								<div class="table-wrapper col-sm-12" id="">
								<!--Table-->
									<table id="tbl-fondomesa" class="ts table table-striped table-bordered dataTable table-sm" cellspacing="0" width="100%" data-id="fondomesa">
										<thead>
											<tr>								
												<th>#</th>
												<th>Empresa Ejecutora</th>
												<th>P.M.</th>
												<th>P.A.</th>
												<th>#</th>
												<th>L.Formativa</th>
												<th>#</th>
												<th>Línea</th>
												<th>L.M.</th>
												<th>Reg.</th>
												<!--10-->
												<th>Contraparete Técnica</th>
												<th>N° Res. Aprueba Contrato</th>
												<th>Fecha Res. Contrato</th>
												<th>Año</th>
												<th>Inicio</th>
												<th>Estado Inf.n°1</th>
												<th>Fecha Pago cuota n°1</th>
												<th>Informe Inicio Fecha Aceptado</th>
												<th></th>
												<th>Estado Inf.n°2</th>
												<!--20-->
												<th>Fecha Pago cuota n°2</th>
												<th>Informe  Fecha Aceptado</th>
												<th>Final</th>
												<th>Estado Inf.n°3</th>
												<th>Fecha Pago cuota n°3</th>
												<th>Ceremonia de Cierre</th>	
												<th>Informe Final Fecha Aceptado</th>	
												<th>Hito</th>
												<th>Estado</th>
												<th>Región</th>
												<!--30-->
												<th>Comuna</th>												
												<th>Nombre Revisor</th>
												<th>Apellido Revisor</th>												
												<th>Mail Revisor</th>												
												<th>Telefono Revisor</th>
												<th>Direccion Revisor</th>							
												<th>Nombre Ejecutor</th>
												<th>Apellido Ejecutor</th>
												<th>Mail Ejecutor</th>
												<th>Telefono Ejecutor</th>
												<!--40-->
												<th>Direccion Ejecutor</th>												
												<th>Nombre Institucion Ejecutor</th>
												<th>Sexo Ejecutor</th>												
												<th>Encargado Proyecto Mail</th>												
												<th>Encargado Proyecto Celular</th>
												<th>Sexo Encargado Proyecto</th>
												<th>Encargado Actividades</th>
												<th>Encargado Actividades Mail</th>
												<th>Encargado Actividades Celular</th>
												<th>Sexo Encargado Actividades</th>
												<!--50-->
												<th>Informe Inicio FechaEnvio</th>																
												<th>Informe Final Fecha Envio</th>
												<th>Creacion Proyecto Fecha Envio</th>													
												<th>Informe Inicio Aceptado</th>												
												<th>Informe  Aceptado</th>	
												<th>Informe Final Aceptado</th>													
												<th>Direccion de Lanzamiento</th>			
												<th>Fecha de Lanzamiento</th>	
												<th>Hora de Lanzamiento</th>			
												<th>Direccion de Cierre</th>												
												<!--60-->
												<th>Hora de Cierre</th>
												<th>Dias para vencimiento Inf.Inicial</th>												
												<th>Dias para vencimiento Inf.</th>												
												<th>Dias para vencimiento Inf.Final</th>
												<th>%Avance</th>
												<th>%Retraso</th>
												<th>Avance Ejecución Presupuestaria</th>
											</tr>
										</thead>
										<tbody>
										</tbody>
									</table>

								</div>
							</div>
						</div>
						<!-- Table with panel -->		
					</div>	  
				</div>
				<!--wrapper-editor-->

			</div>
			<!--tab2-->				
		</div>
		<!--tab-content-->
	</div>
	<!--container-nav-->	
</div>
<!--container-body-->
	
<script>
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	var LFO_Id=0, LIN_Id=0;
	$(document).ready(function() {	
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);				
		$(".mCustomScrollbar").mCustomScrollbar({
			theme:scrollTheme,
			advanced:{
				autoExpandHorizontalScroll:true,
				updateOnContentResize:true,
				autoExpandVerticalScroll:true,
				scrollbarPosition:"outside"
			},
		});	
			
		$(".content-nav").tabsmaterialize({},function(){
			var FON_Id = $(this.toString()).data("fon");
			if(FON_Id==1){			
				if ( ! $.fn.DataTable.isDataTable( '#tbl-fondoescuela' ) ) {
				 	tablefondoEscuela(FON_Id,<%=tpo%>)					
				}else{
					fondoescuelaTable.ajax.reload();
				}
			}
			if(FON_Id==2){
				if ( ! $.fn.DataTable.isDataTable( '#tbl-fondomesa' ) ) {
				 	tablefondoMesa(FON_Id,<%=tpo%>)					
				}else{
					fondomesaTable.ajax.reload();
				}
			}
		});				
		
		$(".buttonExport").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var idTable = $(this).data("id")

			const inputValue=idTable + '.csv';
			const { value: csvFilename } = swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Ingresa el nombre del archivo',
				input: 'text',
				inputValue: inputValue,
				showCancelButton: true,
				confirmButtonText: '<i class="fas fa-sync-alt"></i> Generar',
				cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar',
				inputValidator: (value) => {
				if (!value) {
				  return 'Debes escribir un nombre de archivo!';
				}
			  }
			}).then((result) => {
				if(result.value){				
					$('#tbl-'+idTable).exporttocsv({
						fileName  : result.value,
						separator : ';',
						table	  : 'dt'
					});				
				}

			});							
		});	
		
		//FondoEscuela
		var fondoescuelaTable;
		function tablefondoEscuela(FON_Id,tipo){			
			var tables = $.fn.dataTable.fnTables(true);
			if(tipo==1){
				var targets=[4,5,13,14,17,18,21,22,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66]
				var ancho = [0,2,3,8,9,11,12,15,16,19,20,23,24,25]
				var autoWidth = false
			}
			if(tipo==2){
				var targets=[4,5,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65]
				var ancho=[]
				var autoWidth = true
			}
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			fondoescuelaTable = $('#tbl-fondoescuela').DataTable({
				lengthMenu: [ 5,10,15,20 ],
				ajax:{
					url:"<%=url_fondoescuela%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:tipo,FON_Id:FON_Id}					
				},	
				columnDefs: [{					
					"targets":targets,
					"visible": false,
					"searchable": false
					},{
					"targets": ancho,"width":"20px"
					},
					{"className" : "barra", "targets": [66]}
				],
				autoWidth: autoWidth,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					var estInf1 = $(aData)[15];
					var estPag1 = $(aData)[16];					
					var estInf2 = $(aData)[19];
					var estPag2 = $(aData)[20];
					var estInf3 = $(aData)[23];
					var estPag3 = $(aData)[24];											
					
					if(estInf1=="No Aceptado" || estInf1=="En Curso"){
						$(nRow).find("td").eq(10).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(10).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag1=="Pendiente"){
						$(nRow).find("td").eq(11).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(11).css("background", "rgba(92, 184, 92, .3)");
					}
					
					if(estInf2=="No Aceptado" || estInf2=="En Curso"){
						$(nRow).find("td").eq(12).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(12).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag2=="Pendiente"){
						$(nRow).find("td").eq(13).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(13).css("background", "rgba(92, 184, 92, .3)");
					}
					
					if(estInf3=="No Aceptado" || estInf3=="En Curso"){
						$(nRow).find("td").eq(14).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(14).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag3=="Pendiente"){
						$(nRow).find("td").eq(15).css("background", "rgba(217, 83, 79, .3)");
					}else{					
						$(nRow).find("td").eq(15).css("background", "rgba(92, 184, 92, .3)");
					}
					
					
					if(tipo==2){
						var porSI = $(aData)[64];	
						var porNO = $(aData)[65];						
						var $elemnt = $(this)
						
						if(porSI!=undefined){
							setTimeout(function() {
								if($elemnt.is(':visible') && parseInt(porSI)>0) {									
									$($(nRow).find("td").eq(9)).find("span").css("visibility","visible")
									$($(nRow).find("td").eq(9)).find("span.ok").css("width",porSI+"%");
									$($(nRow).find("td").eq(9)).find("span.nok").css("width",porNO+"%");
								}
							}, 500);										
						}
					}
					
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '<%=url%>',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}
		
		//FondoMesa
		var fondomesaTable;
		function tablefondoMesa(FON_Id,tipo){			
			var tables = $.fn.dataTable.fnTables(true);
			if(tipo==1){
				var targets=[4,5,13,14,17,18,21,22,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66]
				var ancho = [0,2,3,8,9,11,12,15,16,19,20,23,24,25]
				var autoWidth = false
			}
			if(tipo==2){
				var targets=[4,5,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65]
				var ancho=[]
				var autoWidth = true
			}
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			fondomesaTable = $('#tbl-fondomesa').DataTable({
				lengthMenu: [ 5,10,15,20 ],
				ajax:{
					url:"<%=url_fondoescuela%>",					
					type:"POST",
					dataSrc:function(json){					
						return json.data;					
					},
					data:{tpo:tipo,FON_Id:FON_Id}					
				},	
				columnDefs: [{					
					"targets":targets,
					"visible": false,
					"searchable": false
					},{
					"targets": ancho,"width":"20px"
					},
					{"className" : "barra", "targets": [66]}
				],
				autoWidth: autoWidth,				
				order:[0,"desc"],
				fnRowCallback: function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
					var estInf1 = $(aData)[15];
					var estPag1 = $(aData)[16];					
					var estInf2 = $(aData)[19];
					var estPag2 = $(aData)[20];
					var estInf3 = $(aData)[23];
					var estPag3 = $(aData)[24];											
					
					if(estInf1=="No Aceptado" || estInf1=="En Curso"){
						$(nRow).find("td").eq(10).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(10).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag1=="Pendiente"){
						$(nRow).find("td").eq(11).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(11).css("background", "rgba(92, 184, 92, .3)");
					}
					
					if(estInf2=="No Aceptado" || estInf2=="En Curso"){
						$(nRow).find("td").eq(12).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(12).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag2=="Pendiente"){
						$(nRow).find("td").eq(13).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(13).css("background", "rgba(92, 184, 92, .3)");
					}
					
					if(estInf3=="No Aceptado" || estInf3=="En Curso"){
						$(nRow).find("td").eq(14).css("background", "rgba(217, 83, 79, .3)");						
					}else{					
						$(nRow).find("td").eq(14).css("background", "rgba(92, 184, 92, .3)");
					}
					if(estPag3=="Pendiente"){
						$(nRow).find("td").eq(15).css("background", "rgba(217, 83, 79, .3)");
					}else{					
						$(nRow).find("td").eq(15).css("background", "rgba(92, 184, 92, .3)");
					}
					
					
					if(tipo==2){
						var porSI = $(aData)[64];	
						var porNO = $(aData)[65];	
						
						var $elemnt = $(this)
						if(porSI!=undefined){
							setTimeout(function() {
								if($elemnt.is(':visible') && parseInt(porSI)>0) {									
									$($(nRow).find("td").eq(9)).find("span").css("visibility","visible")
									$($(nRow).find("td").eq(9)).find("span.ok").css("width",porSI+"%");
									$($(nRow).find("td").eq(9)).find("span.nok").css("width",porNO+"%");
								}
							}, 500);										
						}
					}
					
					$(nRow).click(function(e){
						e.preventDefault();
						e.stopImmediatePropagation();
						e.stopPropagation();

						var PRY_Id=$(this).find("td")[0].innerText;
						var LIN_Id=$(this).find("td")[4].innerText;
						$.ajax( {
							type:'POST',					
							url: '<%=url%>',
							data: {key2:PRY_Id,key1:LIN_Id},
							success: function ( data ) {
								param = data.split(sas)
								if(param[0]==200){						
									$("#contenbody").html(param[1]);
									var href = window.location.href;
									var newhref = href.substr(href.indexOf("/home")+6,href.length);
									var href_split = newhref.split("/")

									href_split[1]="modificar";
									href_split[2]=LIN_Id;
									href_split[3]=PRY_Id;
									var newurl="/home"
									$.each(href_split, function(i,e){
										newurl=newurl + "/" + e
									});
									window.history.replaceState(null, "", newurl);
									cargabreadcrumb("/breadcrumbs","");
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){

							}
						});	
					});
				}
			});
		}								
		
	});
</script>