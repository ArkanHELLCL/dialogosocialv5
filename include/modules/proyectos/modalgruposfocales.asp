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
	response.write("200\\#gruposfocalesModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-user-friends"></i> Grupos Focales</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">																				
				<div id="frmGruposFocalesAdd" class="px-4">

					
				</div>
				<!--div frmGruposFocalesAdd-->				
				<!--container-nav-->
				<div class="container-nav" style="margin-right: 15px;margin-left: 15px;margin-bottom: 20px;width:auto;" id="frmGruposFocales">
					<div class="header">				
						<div class="content-nav">
							<a id="repsin-tab" href="#sindicatogfotab1" class="active tab"><i class="fas fa-users"></i> Grupo Focal Sindicato 						
							</a>
							<a id="repemp-tab" href="#empresasgfotab2" class="tab"><i class="fas fa-industry"></i> Grupo Focal Empresa 						
							</a><%
							if PRY_TipoMesa=2 then		'Tripartita%>
								<a id="repgob-tab" href="#gobiernogfotab3" class="tab"><i class="fas fa-university"></i> Grupo Focal Gobierno 							
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
						<!--sindicatogfotab1-->
						<div id="sindicatogfotab1" class="tabs-pane">															
							<div class="table-wrapper " id="container-table-sindicatoGFO">
								<table id="tbl-sindicatoGFO" class="ts table table-striped table-bordered dataTable table-sm" data-id="sindicatoGFO" data-page="true" data-selected="true" data-keys="1" width="99%"> 
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
											<th>Int.</th>
											<th></th>
										</tr>
									</thead>
								</table>
							</div>							
						</div>
						<!--empresastab1-->
						<div id="empresasgfotab2" class="tabs-pane">															
							<div class="table-wrapper " id="container-table-EmpresaGFO">
								<table id="tbl-EmpresaGFO" class="ts table table-striped table-bordered dataTable table-sm" data-id="EmpresaGFO" data-page="true" data-selected="true" data-keys="1" width="99%"> 
									<thead> 
										<tr> 
											<th>#</th>
											<th>Empresa</th> 
											<th>ROL</th>											
											<th>Rama</th>
											<th>H</th>
											<th>M</th>
											<th>T</th>
											<th>Int.</th>
											<th></th>
										</tr>
									</thead>
								</table>
							</div>							
						</div>
						<!--gobiernotab1--><%
						if PRY_TipoMesa=2 then%>
							<div id="gobiernogfotab3" class="tabs-pane">															
								<div class="table-wrapper " id="container-table-GobiernoGFO">
									<table id="tbl-GobiernoGFO" class="ts table table-striped table-bordered dataTable table-sm" data-id="GobiernoGFO" data-page="true" data-selected="true" data-keys="1" width="99%"> 
										<thead> 
											<tr> 
												<th>#</th>
												<th>Servicio</th> 
												<th>Ministerio</th>												
												<th>Int.</th>
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
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id=""><i class="fas fa-download ml-1"></i></button>
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
								
		var sindicatoGFOTable;
		var empresasGFOTable;
		var GobiernoGFOTable;
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
		
		$("#frmGruposFocales").tabsmaterialize({menumovil:false,contentAnimation:false},function(){});
		$("#gruposfocalesModal").on('show.bs.modal', function(e){					
			
		})		
							
		function loadTableGruposFocales() {
			if($.fn.DataTable.isDataTable( "#tbl-sindicatoGFO")){				
				if(sindicatoGFOTable!=undefined){
					sindicatoGFOTable.destroy();
				}else{
					$('#tbl-sindicatoGFO').dataTable().fnClearTable();
    				$('#tbl-sindicatoGFO').dataTable().fnDestroy();
				}
			}				
			sindicatoGFOTable = $("#tbl-sindicatoGFO").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/grupofocal-sindicatos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}
			});
			if($.fn.DataTable.isDataTable( "#tbl-EmpresaGFO")){				
				if(empresasGFOTable!=undefined){
					empresasGFOTable.destroy();
				}else{
					$('#tbl-EmpresaGFO').dataTable().fnClearTable();
    				$('#tbl-EmpresaGFO').dataTable().fnDestroy();
				}
			}			
			empresasGFOTable = $("#tbl-EmpresaGFO").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/grupofocal-empresas",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}				
			});
			if($.fn.DataTable.isDataTable( "#tbl-GobiernoGFO")){				
				if(GobiernoGFOTable!=undefined){
					GobiernoGFOTable.destroy();
				}else{
					$('#tbl-GobiernoGFO').dataTable().fnClearTable();
    				$('#tbl-GobiernoGFO').dataTable().fnDestroy();
				}
			}			
			GobiernoGFOTable = $("#tbl-GobiernoGFO").DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/grupofocal-gobierno",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				}				
			});
			
			$('#tbl-sindicatoGFO').css('width','99%');
			$('#tbl-EmpresaGFO').css('width','99%');
			$('#tbl-GobiernoGFO').css('width','99%');
			/*$(".row").css("width","100%");
			$(".row").css("margin","0");*/
		}							
		
		/*Sindicatos*/		
		var grupofocalSINTable;
		
		$("#gruposfocalesModal").on("click",".addgfosin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var SIN_Id	= $(this).data("sin");
			
			$.ajax( {
				type:'POST',					
				url: '/grupofocal-sindicatos-modal',
				data:{PRY_Id:<%=PRY_Id%>,SIN_Id:SIN_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmGruposFocalesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-gruposfocalesSIN")){				
							if(grupofocalSINTable!=undefined){
								grupofocalSINTable.destroy();
							}else{
								$('#tbl-gruposfocalesSIN').dataTable().fnClearTable();
								$('#tbl-gruposfocalesSIN').dataTable().fnDestroy();
							}
						}
						grupofocalSINTable = $('#tbl-gruposfocalesSIN').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-gruposfocales-sindicato",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,SIN_Id:SIN_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmGruposFocalesAdd").css("height")=="500px"){				
				$("#frmGruposFocalesAdd").css("height","0");								
				$('#frmGruposFocales').animate({
					height: $('#frmGruposFocales').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmGruposFocalesAdd").css("height","500px");				
				$("#frmGruposFocales").css("height","0");				
			}
						
		})		
		
		$("#gruposfocalesModal").on("click",".delgfosin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var GFS_Id	= $(this).data("gfs");
			
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
						url: '/eliminar-gruposfocales-sindicato',
						data:{GFS_Id:GFS_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								grupofocalSINTable.ajax.reload();
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
		
		$("#gruposfocalesModal").on("click","#btn_frmaddgruposfocalessin",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			
			formValidate("#frmGruposFocalesForm");
			if($("#frmGruposFocalesForm").valid()){				
				$.ajax( {
					type:'POST',					
					url: '/agregar-gruposfocales-sindicato',
					data: $("#frmGruposFocalesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmGruposFocalesForm")[0].reset();
							grupofocalSINTable.ajax.reload();
							Toast.fire({
							  icon: 'success',
							  title: 'Integrante de sindicato agregado exitosamente.'
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del Integrante',					
								text:data.message
							});				
						}
					}
				})
			}			
		})								
		
		$("#gruposfocalesModal").on("click", ".vergfosin", function() {
			var tr = $(this).closest('tr');
			var row = sindicatoGFOTable.row(tr);			
			
			var id=$(this).data("sin");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".vergfosin").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaSINGFO(row.data(),"tbl-vergfoSIN_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".vergfosin").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaSINGFO(rowData,table_id,SIN_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-gruposfocales-sindicato',
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
		var grupofocalEMPTable;
		
		$("#gruposfocalesModal").on("click",".addgfoemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var EMP_Id	= $(this).data("emp");
			
			$.ajax( {
				type:'POST',					
				url: '/grupofocal-empresas-modal',
				data:{PRY_Id:<%=PRY_Id%>,EMP_Id:EMP_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmGruposFocalesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-gruposfocalesEMP")){				
							if(grupofocalEMPTable!=undefined){
								grupofocalEMPTable.destroy();
							}else{
								$('#tbl-gruposfocalesEMP').dataTable().fnClearTable();
								$('#tbl-gruposfocalesEMP').dataTable().fnDestroy();
							}
						}
						grupofocalEMPTable = $('#tbl-gruposfocalesEMP').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-gruposfocales-empresa",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,EMP_Id:EMP_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmGruposFocalesAdd").css("height")=="500px"){				
				$("#frmGruposFocalesAdd").css("height","0");								
				$('#frmGruposFocales').animate({
					height: $('#frmGruposFocales').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmGruposFocalesAdd").css("height","500px");				
				$("#frmGruposFocales").css("height","0");				
			}
						
		})		
		
		$("#gruposfocalesModal").on("click",".delgfoemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var GFE_Id	= $(this).data("gfe");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Con esta acción eliminarás el integrante seleccioando",
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
						url: '/eliminar-gruposfocales-empresa',
						data:{GFE_Id:GFE_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								grupofocalEMPTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Integrante de empresa eliminado exitosamente.'
								});
							}
						}
					})	
			  	}
			})						
		})
		
		$("#gruposfocalesModal").on("click","#btn_frmaddgruposfocalesemp",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			
			formValidate("#frmGruposFocalesForm");
			if($("#frmGruposFocalesForm").valid()){				
				$.ajax( {
					type:'POST',					
					url: '/agregar-gruposfocales-empresa',
					data: $("#frmGruposFocalesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmGruposFocalesForm")[0].reset();
							grupofocalEMPTable.ajax.reload();
							Toast.fire({
							  icon: 'success',
							  title: 'Integrante de empresa agregado exitosamente.'
							});
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude grabar los datos del integrante',					
								text:data.message
							});				
						}
					}
				})
			}			
		})								
		
		$("#gruposfocalesModal").on("click", ".vergfoemp", function() {
			var tr = $(this).closest('tr');
			var row = empresasGFOTable.row(tr);			
			
			var id=$(this).data("emp");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".vergfoemp").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaEMPGFO(row.data(),"tbl-vergfoEMP_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".vergfoemp").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaEMPGFO(rowData,table_id,EMP_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-gruposfocales-empresa',
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
		var grupofocalGOBTable;
		
		$("#gruposfocalesModal").on("click",".addgfogob",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var SER_Id	= $(this).data("ser");
			
			$.ajax( {
				type:'POST',					
				url: '/gruposfocales-gobierno-modal',
				data:{PRY_Id:<%=PRY_Id%>,SER_Id:SER_Id},
				success: function ( data ) {
					var param = data.split(ss)
					if(param[0]=="200"){
						$("#frmGruposFocalesAdd").html(param[1]);
						tooltipfunction();
						
						if($.fn.DataTable.isDataTable( "#tbl-gruposfocalesGOB")){				
							if(grupofocalGOBTable!=undefined){
								grupofocalGOBTable.destroy();
							}else{
								$('#tbl-gruposfocalesGOB').dataTable().fnClearTable();
								$('#tbl-gruposfocalesGOB').dataTable().fnDestroy();
							}
						}
						grupofocalGOBTable = $('#tbl-gruposfocalesGOB').DataTable({
							lengthMenu: [ 3 ],
							ajax:{
								url:"/carga-gruposfocales-gobierno",
								type:"POST",
								data:{PRY_Id:<%=PRY_Id%>,SER_Id:SER_Id}
								
							}
						});	
					}
				}
			})
						
			if($("#frmGruposFocalesAdd").css("height")=="500px"){				
				$("#frmGruposFocalesAdd").css("height","0");								
				$('#frmGruposFocales').animate({
					height: $('#frmGruposFocales').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');
				});				
				
			}else{								
				$("#frmGruposFocalesAdd").css("height","500px");				
				$("#frmGruposFocales").css("height","0");				
			}
						
		})		
		
		$("#gruposfocalesModal").on("click",".delgfogob",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var GFG_Id	= $(this).data("gfg");
			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Con esta acción eliminarás el integrante seleccioando",
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
						url: '/eliminar-gruposfocales-gobierno',
						data:{GFG_Id:GFG_Id},
						dataType:'json',
						success: function ( data ) {					
							if(data.state=="200"){												
								grupofocalGOBTable.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Integrante de gobierno eliminado exitosamente.'
								});
							}
						}
					})	
			  	}
			})						
		})
		
		$("#gruposfocalesModal").on("click","#btn_frmaddgruposfocalesGOB",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			
			formValidate("#frmGruposFocalesForm");
			if($("#frmGruposFocalesForm").valid()){				
				$.ajax( {
					type:'POST',					
					url: '/agregar-gruposfocales-gobierno',
					data: $("#frmGruposFocalesForm").serialize(),
					dataType:"json",
					success: function ( data ) {						
						if(data.state==200){
							$("#frmGruposFocalesForm")[0].reset();
							grupofocalGOBTable.ajax.reload();
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
			}			
		})								
		
		$("#gruposfocalesModal").on("click", ".vergfogob", function() {
			var tr = $(this).closest('tr');
			var row = GobiernoGFOTable.row(tr);			
			
			var id=$(this).data("ser");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".vergfogob").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuestaGOBGFO(row.data(),"tbl-vergfoGOB_" + iTermGPACounter ,id)).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".vergfogob").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		function formatRespuestaGOBGFO(rowData,table_id,SER_Id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );

			$.ajax( {
				type:'POST',
				url: '/visualiza-gruposfocales-gobierno',
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
		
		
		$("#gruposfocalesModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$(document).off('focusin.modal');
			$("body").addClass("modal-open");
			loadTableGruposFocales();
			exportTable();
		});	
		
		$("#gruposfocalesModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("body").removeClass("modal-open")
			$("#frmGruposFocalesAdd").css("height","0");			
			
			$('#frmGruposFocales').animate({
				height: $('#frmGruposFocales').get(0).scrollHeight
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
		
		$("#gruposfocalesModal").on("click","#btn_salirgruposfocales",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			sindicatoGFOTable.ajax.reload();
			empresasGFOTable.ajax.reload();
			GobiernoGFOTable.ajax.reload();			
			
			if($("#frmGruposFocalesAdd").css("height")=="500px"){				
				$("#frmGruposFocalesAdd").css("height","0");								
				$('#frmGruposFocales').animate({
					height: $('#frmGruposFocales').get(0).scrollHeight
				}, 700, function(){
					$(this).height('auto');					
				});				
			}			
		})	
		
		$("body").append("<button id='btn_modalgruposfocales' name='btn_modalgruposfocales' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalgruposfocales").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#gruposfocalesModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalgruposfocales").click();		
		$("#btn_modalgruposfocales").remove();
	})
</script>