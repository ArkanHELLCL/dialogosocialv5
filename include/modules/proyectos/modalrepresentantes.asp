<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	if(session("ds5_usrperfil")=5) then	'Adminsitrativo
	   response.Write("403\\Error Perfil no autorizado")
	   response.End() 
	end if
	splitruta=split(ruta,"/")
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	
	if(xm="modificar") then
		modo=2
		mode="mod"
		required="required"
	end if
	if(xm="visualizar") or (session("ds5_usrperfil")=4) or (session("ds5_usrperfil")=2) then
		modo=4
		mode="vis"
		required="disabled"
	end if		
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503\\Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if	
	
	set rs = cnn.Execute("exec spProyecto_Consultar " & PRY_Id)
	
	if not rs.eof then		
		USR_IdRevisor=rs("USR_IdRevisor")
		USR_IdEjecutor=rs("USR_IdEjecutor")
		PRY_Estado=rs("PRY_Estado")
		PRY_Identificador=rs("PRY_Identificador")
		PRY_IdLicitacion=rs("PRY_IdLicitacion")
		PRY_NombreLicitacion=rs("PRY_NombreLicitacion")
		FON_Nombre=rs("FON_Nombre")
		PRY_NumResAprueba=rs("PRY_NumResAprueba")
		PRY_FechaResolucion=rs("PRY_FechaResolucion")
		PRY_Adjunto=rs("PRY_Adjunto")
		LIN_Hombre= rs("LIN_Hombre")
		LIN_Mujer= rs("LIN_Mujer")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")
		PRY_TipoMesa=rs("PRY_TipoMesa")		
		'Linea 11 Mesa de Dialogo
		PRY_InformeInicialFecha          = rs("PRY_InformeInicialFecha")
		PRY_InformeConsensosFecha        = rs("PRY_InformeConsensosFecha")
		PRY_InformeSistematizacionFecha  = rs("PRY_InformeSistematizacionFecha")
		PRY_InformeInicialEstado         = rs("PRY_InformeInicialEstado")
		if (PRY_InformeInicialEstado="" or isnull(PRY_InformeInicialEstado)) then
			PRY_InformeInicialEstado=0
		end if
		PRY_InformeConsensosEstado       = rs("PRY_InformeConsensosEstado")
		if (PRY_InformeConsensosEstado="" or isnull(PRY_InformeConsensosEstado)) then
			PRY_InformeConsensosEstado=0
		end if
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		if (PRY_InformeSistematizacionEstado="" or isnull(PRY_InformeSistematizacionEstado)) then
			PRY_InformeSistematizacionEstado=0
		end if
	end if
	columnsDefsVerificadores="[]"
	response.write("200\\#RepresentantesModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-users"></i> Representantes</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">																				
				<div id="frmRepresentantesAdd" class="px-4">					
				</div>
				<!--div frmRepresentantesAdd-->				
				<!--container-nav-->
				<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;width:auto;" id="frmRepresentantes">
					<div class="header">				
						<div class="content-nav">
							<a id="repsin-tab" href="#sindicatoreptab1" class="active tab"><i class="fas fa-users"></i> Representantes Sindicato 						
							</a>
							<a id="repemp-tab" href="#empresasreptab2" class="tab"><i class="fas fa-industry"></i> Representantes Empresa 						
							</a><%
							if PRY_TipoMesa=2 then		'Tripartita%>
								<a id="repgob-tab" href="#gobiernoreptab3" class="tab"><i class="fas fa-university"></i> Representantes Gobierno 							
								</a><%
							end if%>
							<span class="yellow-bar"></span>				
							<button class="tab-toggler first-button" type="button" aria-expanded="false" aria-label="Toggle navigation">
								<div class="animated-icon1"><span></span><span></span><span></span></div>
							</button>
						</div>				
					</div>
					<!--tab-content-->
					<div class="tab-content tab-validate">
						<!--sindicatoreptab1-->
						<div id="sindicatoreptab1" class="tabs-pane">
							<div class="table-wrapper " id="container-table-sindicatoREP">
								<table id="tbl-sindicatoREP" class="ts table table-striped table-bordered dataTable table-sm" data-id="sindicatoREP" data-page="true" data-selected="true" data-keys="1" width="99%"> 
									<thead> 
										<tr> 
											<th>#</th>
											<th>Sindicato</th> 
											<th>RUT</th>								
											<th>Tipo</th>
											<th>Rama</th>
											<th>H</th>
											<th>M</th>
											<th>T</th>
											<th>Rep.</th>
											<th></th>
										</tr>
									</thead>
								</table>
							</div>							
						</div>
						<!--empresastab1-->
						<div id="empresasreptab2" class="tabs-pane">
							<div class="table-wrapper " id="container-table-EmpresaREP">
								<table id="tbl-EmpresaREP" class="ts table table-striped table-bordered dataTable table-sm" data-id="EmpresaREP" data-page="true" data-selected="true" data-keys="1" width="99%"> 
									<thead> 
										<tr> 
											<th>#</th>
											<th>Empresa</th> 
											<th>ROL</th>											
											<th>Rama</th>
											<th>H</th>
											<th>M</th>
											<th>T</th>
											<th>Rep.</th>
											<th></th>
										</tr>
									</thead>
								</table>
							</div>							
						</div>
						<!--gobiernotab1--><%
						if PRY_TipoMesa=2 then%>
							<div id="gobiernoreptab3" class="tabs-pane">
								<div class="table-wrapper " id="container-table-GobiernoREP">
									<table id="tbl-GobiernoREP" class="ts table table-striped table-bordered dataTable table-sm" data-id="GobiernoREP" data-page="true" data-selected="true" data-keys="1" width="99%"> 
										<thead> 
											<tr> 
												<th>#</th>
												<th>Servicio</th> 
												<th>Ministerio</th>												
												<th>Rep.</th>
												<th></th>
											</tr>
										</thead>
									</table>
								</div>							
							</div><%
						end if%>
					</div>
					<!--tab-content-->
				</div>
				<!--container-nav-->
				
			</div>
			<!--body-->
			<div class="modal-footer">				
				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="verificadorespry"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->

<script>	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);		
								
		var sindicatoREPTable;
		var empresasREPTable;
		var gobiernoREPTable;
		var iTermGPACounter = 1;	
		
		function tooltipfunction(){
			$('[data-toggle="tooltip"]').tooltip({
				trigger : 'hover'
			})
			$('[data-toggle="tooltip"]').on('click', function () {
				$(this).tooltip('hide')
			})	
			
			var titani = setInterval(function(){				
				$("h5").slideDown("slow",function(){
					$("h6").slideDown("slow",function(){
						clearInterval(titani)
					});
				})
			},2300);
		}
		tooltipfunction();
		
		$("#frmRepresentantes").tabsmaterialize({menumovil:false,contentAnimation:false},function(){});
		$("#RepresentantesModal").on('show.bs.modal', function(e){					
			
		})		
							
		function loadTableRepresentantes() {
			if($.fn.DataTable.isDataTable( "#tbl-sindicatoREP")){				
				if(sindicatoREPTable!=undefined){
					sindicatoREPTable.destroy();
				}else{
					$('#tbl-sindicatoREP').dataTable().fnClearTable();
    				$('#tbl-sindicatoREP').dataTable().fnDestroy();
				}
			}				
			sindicatoREPTable = $("#tbl-sindicatoREP").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/representante-sindicatos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});
			if($.fn.DataTable.isDataTable( "#tbl-EmpresaREP")){				
				if(empresasREPTable!=undefined){
					empresasREPTable.destroy();
				}else{
					$('#tbl-EmpresaREP').dataTable().fnClearTable();
    				$('#tbl-EmpresaREP').dataTable().fnDestroy();
				}
			}			
			empresasREPTable = $("#tbl-EmpresaREP").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/representante-empresas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}				
			});
			if($.fn.DataTable.isDataTable( "#tbl-GobiernoREP")){				
				if(gobiernoREPTable!=undefined){
					gobiernoREPTable.destroy();
				}else{
					$('#tbl-GobiernoREP').dataTable().fnClearTable();
    				$('#tbl-GobiernoREP').dataTable().fnDestroy();
				}
			}			
			gobiernoREPTable = $("#tbl-GobiernoREP").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/representante-gobierno",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}				
			});
			
			$('#tbl-sindicatoREP').css('width','99%');
			$('#tbl-EmpresaREP').css('width','99%');
			$('#tbl-GobiernoREP').css('width','99%');
			/*$(".row").css("width","100%");
			$(".row").css("margin","0");*/
		}							
		
		/*Sindicatos*/		
		var representanteSINTable;
		
		$("#RepresentantesModal").on("click",".addrepsin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var SIN_Id	= $(this).data("sin");
			
			$.ajax( {
				type:'POST',					
				url: '/representates-sindicatos-modal',
				data:{PRY_Id:<%=PRY_Id%>,SIN_Id:SIN_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmRepresentantesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-representantesSIN")){				
							if(representanteSINTable!=undefined){
								representanteSINTable.destroy();
							}else{
								$('#tbl-representantesSIN').dataTable().fnClearTable();
								$('#tbl-representantesSIN').dataTable().fnDestroy();
							}
						}
						representanteSINTable = $('#tbl-representantesSIN').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-representantes-sindicato",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,SIN_Id:SIN_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmRepresentantesAdd").css("height")=="500px"){				
				$("#frmRepresentantesAdd").css("height","0");								
				$('#frmRepresentantes').animate({
					height: $('#frmRepresentantes').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmRepresentantesAdd").css("height","500px");				
				$("#frmRepresentantes").css("height","0");				
			}
						
		})		
		
		$("#RepresentantesModal").on("click",".delrepsin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var RPS_Id	= $(this).data("rps");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Con esta acción eliminarás el representante seleccioando",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax( {
						type:'POST',					
						url: '/eliminar-representante-sindicato',
						data:{RPS_Id:RPS_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								representanteSINTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Representante de sindicato eliminado exitosamente.'
								});
							}
						}
					})	
			  	}
			})						
		})
		
		$("#RepresentantesModal").on("click","#btn_frmaddrepresentantessin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();		
			$("#RPS_Rut").Rut();
			
			formValidate("#frmrepresentantesForm");
			if($("#frmrepresentantesForm").valid()){
				$("#Rut_RPS").val($("#RPS_Rut").val().replace(/[($)\s\._\-]+/g, ''));
				$.ajax( {
					type:'POST',					
					url: '/agregar-representante-sindicato',
					data: $("#frmrepresentantesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmrepresentantesForm")[0].reset();
							representanteSINTable.ajax.reload();
							Toast.fire({
							  icon: 'success',
							  title: 'Representante de sindicato agregado exitosamente.'
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del representante',					
								text:data.message
							});				
						}
					}
				})
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}			
		})								
		
		$("#RepresentantesModal").on("click", ".verrepsin", function() {
			var tr = $(this).closest('tr');
			var row = sindicatoREPTable.row(tr);			
			
			var id=$(this).data("sin");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".verrepsin").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaSIN(row.data(),"tbl-verrepSIN_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".verrepsin").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaSIN(rowData,table_id,SIN_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-representante-sindicato',
				data: {PRY_Id:<%=PRY_Id%>,SIN_Id:SIN_Id,table:table_id},
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}						
						$("#" + table_id).DataTable({								
							lengthMenu: [ 3, 6, 10 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}
		/*Sindicatos*/
		
		
		/*Empresas*/
		var representanteEMPTable;
		
		$("#RepresentantesModal").on("click",".addrepemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var EMP_Id	= $(this).data("emp");
			
			$.ajax( {
				type:'POST',					
				url: '/representates-empresas-modal',
				data:{PRY_Id:<%=PRY_Id%>,EMP_Id:EMP_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmRepresentantesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-representantesEMP")){				
							if(representanteEMPTable!=undefined){
								representanteEMPTable.destroy();
							}else{
								$('#tbl-representantesEMP').dataTable().fnClearTable();
								$('#tbl-representantesEMP').dataTable().fnDestroy();
							}
						}
						representanteEMPTable = $('#tbl-representantesEMP').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-representantes-empresa",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,EMP_Id:EMP_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmRepresentantesAdd").css("height")=="500px"){				
				$("#frmRepresentantesAdd").css("height","0");								
				$('#frmRepresentantes').animate({
					height: $('#frmRepresentantes').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmRepresentantesAdd").css("height","500px");				
				$("#frmRepresentantes").css("height","0");				
			}
						
		})		
		
		$("#RepresentantesModal").on("click",".delrepemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var RPE_Id	= $(this).data("rpe");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Con esta acción eliminarás el representante seleccioando",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax( {
						type:'POST',					
						url: '/eliminar-representante-empresa',
						data:{RPE_Id:RPE_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								representanteEMPTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Representante de empresa eliminado exitosamente.'
								});
							}
						}
					})	
			  	}
			})						
		})
		
		$("#RepresentantesModal").on("click","#btn_frmaddrepresentantesemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();		
			$("#RPE_Rut").Rut();
			
			formValidate("#frmrepresentantesForm");
			if($("#frmrepresentantesForm").valid()){
				$("#Rut_RPE").val($("#RPE_Rut").val().replace(/[($)\s\._\-]+/g, ''));
				$.ajax( {
					type:'POST',					
					url: '/agregar-representante-empresa',
					data: $("#frmrepresentantesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmrepresentantesForm")[0].reset();
							representanteEMPTable.ajax.reload();
							Toast.fire({
							  icon: 'success',
							  title: 'Representante de empresa agregado exitosamente.'
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del representante',					
								text:data.message
							});				
						}
					}
				})
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})								
		
		$("#RepresentantesModal").on("click", ".verrepemp", function() {
			var tr = $(this).closest('tr');
			var row = empresasREPTable.row(tr);			
			
			var id=$(this).data("emp");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".verrepemp").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaEMP(row.data(),"tbl-verrepEMP_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".verrepemp").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaEMP(rowData,table_id,EMP_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-representante-empresa',
				data: {PRY_Id:<%=PRY_Id%>,EMP_Id:EMP_Id,table:table_id},
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}						
						$("#" + table_id).DataTable({								
							lengthMenu: [ 3, 6, 10 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}
		/*Empresas*/
		
		/*Gobierno*/
		var representanteGOBTable;
		
		$("#RepresentantesModal").on("click",".addrepgob",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var SER_Id	= $(this).data("ser");
			
			$.ajax( {
				type:'POST',					
				url: '/representates-gobierno-modal',
				data:{PRY_Id:<%=PRY_Id%>,SER_Id:SER_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmRepresentantesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-representantesGOB")){				
							if(representanteGOBTable!=undefined){
								representanteGOBTable.destroy();
							}else{
								$('#tbl-representantesGOB').dataTable().fnClearTable();
								$('#tbl-representantesGOB').dataTable().fnDestroy();
							}
						}
						representanteGOBTable = $('#tbl-representantesGOB').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-representantes-gobierno",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,SER_Id:SER_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmRepresentantesAdd").css("height")=="500px"){				
				$("#frmRepresentantesAdd").css("height","0");								
				$('#frmRepresentantes').animate({
					height: $('#frmRepresentantes').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmRepresentantesAdd").css("height","500px");				
				$("#frmRepresentantes").css("height","0");				
			}
						
		})		
		
		$("#RepresentantesModal").on("click",".delrepgob",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var RPG_Id	= $(this).data("rpg");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Con esta acción eliminarás el representante seleccioando",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, eliminar',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> Cancelar'
			}).then((result) => {
				if (result.value) {
					$.ajax( {
						type:'POST',					
						url: '/eliminar-representante-gobierno',
						data:{RPG_Id:RPG_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								representanteGOBTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Representante de gobierno eliminado exitosamente.'
								});
							}
						}
					})	
			  	}
			})						
		})
		
		$("#RepresentantesModal").on("click","#btn_frmaddrepresentantesgob",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();		
			$("#RPG_Rut").Rut();			
			
			formValidate("#frmrepresentantesForm");
			if($("#frmrepresentantesForm").valid()){
				$("#Rut_RPG").val($("#RPG_Rut").val().replace(/[($)\s\._\-]+/g, ''));
				$.ajax( {
					type:'POST',					
					url: '/agregar-representante-gobierno',
					data: $("#frmrepresentantesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmrepresentantesForm")[0].reset();
							$("#JGS_Justificacion").val(data.data);
							representanteGOBTable.ajax.reload();
							Toast.fire({
							  icon: 'success',
							  title: 'Representante de gobierno agregado exitosamente.'
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del representante',					
								text:data.message
							});				
						}
					}
				})
			}else{
				Toast.fire({
					icon: 'error',
					title: 'Existen campos con error, corrige y vuelve a intentar'
				});
			}
		})								
		
		$("#RepresentantesModal").on("click", ".verrepgob", function() {
			var tr = $(this).closest('tr');
			var row = gobiernoREPTable.row(tr);			
			
			var id=$(this).data("ser");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".verrepgob").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaGOB(row.data(),"tbl-verrepGOB_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".verrepgob").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaGOB(rowData,table_id,SER_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-representante-gobierno',
				data: {PRY_Id:<%=PRY_Id%>,SER_Id:SER_Id,table:table_id},
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}						
						$("#" + table_id).DataTable({								
							lengthMenu: [ 3, 6, 10 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}
		/*Gobierno*/
		
		
		$("#RepresentantesModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$(document).off('focusin.modal');
			$("body").addClass("modal-open");
			loadTableRepresentantes();
			exportTable();
		});	
		
		$("#RepresentantesModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").removeClass("modal-open")
			$("#frmRepresentantesAdd").css("height","0");			
			
			$('#frmRepresentantes').animate({
				height: $('#frmRepresentantes').get(0).scrollHeight
			}, 700, function(){
				$(this).height('auto');
			});
			var PAR_Hito = window.location.href.split("/")[8];
			var PAR_Step = window.location.href.split("/")[9];
			var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,PRY_Hito:PAR_Hito,CRT_Step:PAR_Step};
			$.ajax( {
				type:'POST',					
				url: '/mnu-<%=LFO_Id%>',
				data: data,
				success: function ( data ) {
					param = data.split(sas)
					if(param[0]==200){						
						$("#pry-menucontent").html(param[1]);
						moveMark(false);
					}else{
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
							text:param[1]
						});				
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){					
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				}
			});			
		});	
		
		function exportTable(){
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
		}	
		
		$("#RepresentantesModal").on("click","#btn_salirrepresentantes",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			sindicatoREPTable.ajax.reload();
			empresasREPTable.ajax.reload();
			gobiernoREPTable.ajax.reload();			
			
			if($("#frmRepresentantesAdd").css("height")=="500px"){				
				$("#frmRepresentantesAdd").css("height","0");								
				$('#frmRepresentantes').animate({
					height: $('#frmRepresentantes').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})	
		
		$("body").append("<button id='btn_modalrepresentantes' name='btn_modalrepresentantes' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalrepresentantes").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#RepresentantesModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalrepresentantes").click();		
		$("#btn_modalrepresentantes").remove();
	})
</script>