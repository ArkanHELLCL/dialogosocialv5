<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	splitruta=split(ruta,"/")		
	PRY_Id=splitruta(7)
	xm=splitruta(5)
	
	if(xm="modificar") then
		modo=2
		mode="mod"
		required="required"
	end if
	if(xm="visualizar") or (session("ds5_usrperfil")=4) then
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
		PRY_InformeFinalEstado=rs("PRY_InformeFinalEstado")
		PRY_InformeFinalAceptado=rs("PRY_InformeFinalAceptado")
		PRY_InformeSistematizacionEstado = rs("PRY_InformeSistematizacionEstado")
		PRY_InformeSistematizacionAceptado = rs("PRY_InformeSistematizacionAceptado")
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
		PRY_EmpresaEjecutora=rs("PRY_EmpresaEjecutora")
		PRY_Nombre=rs("PRY_Nombre")
		REG_Nombre=rs("REG_Nombre")
		PRY_EncargadoProyecto=rs("PRY_EncargadoProyecto")
		PRY_EncargadoActividades=rs("PRY_EncargadoActividades")
		LIN_Id=rs("LIN_Id")
		LFO_Id=rs("LFO_Id")		
	end if
	if(PRY_InformeFinalEstado="" or IsNULL(PRY_InformeFinalEstado)) then
		PRY_InformeFinalEstado=0
	end if	
	if(PRY_InformeSistematizacionEstado="" or IsNULL(PRY_InformeSistematizacionEstado)) then
		PRY_InformeSistematizacionEstado=0
	end if

	if(PRY_InformeFinalAceptado="" or IsNULL(PRY_InformeFinalAceptado)) then
		PRY_InformeFinalAceptado=0
	end if	
	if(PRY_InformeSistematizacionAceptado="" or IsNULL(PRY_InformeSistematizacionAceptado)) then
		PRY_InformeSistematizacionAceptado=0
	end if

	if(LFO_Id=10 or LFO_Id=12 or LFO_Id=13) then
		PRY_InfFinal = PRY_InformeFinalAceptado
	end if
	if(LFO_Id=11) then
		PRY_InfFinal = PRY_InformeSistematizacionAceptado
	end if
	columnsDefsmensajespry="[]"
	response.write("200\\#mensajespryModal\\")%>
	<div class="modal-dialog cascading-modal narrower modal-full-height modal-bottom" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Mensajes Proyecto</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">				
				<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">											
					<div class="px-4">
						<div class="table-wrapper col-sm-12" id="container-table-mensajespry">
							<!--Table-->
							<table id="tbl-mensajespry" class="table-striped table-bordered table-sm no-hover" cellspacing="0" width="99%" data-id="mensajespry" data-keys="1" data-key1="11" data-url="" data-edit="false" data-header="9" data-ajaxcallview="">
								<thead>										
										<th>id</th>										
										<th>Remitente</th>
										<th>Tipo</th>											
										<th>Mensaje</th>
										<th>Fecha</th>										
										<th class="no-sort">&nbsp;</th>
									</tr>
								</thead>									
							</table>
						</div>
					</div>							
				</div>									
			</div>
			<!--body-->
			<div class="modal-footer"><%				
				if ((PRY_InfFinal=0 and PRY_Estado=1)) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="btn btn-success btn-md waves-effect" type="button" data-url="" title="Crear nuevo mensaje" id="btn_creaconsultapry" name="btn_creaconsultapry"><i class="fas fa-plus ml-1"></i></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">
					<button class="btn btn-default buttonExport btn-md waves-effect" data-toggle="tooltip" title="Exportar datos de la tabla" data-id="mensajespry"><i class="fas fa-download ml-1"></i></button>
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i></button>
				</div>					
			</div>		  
			<!--footer-->				
		</div>
	</div>
	<!--modal-dialogo-->
	
	<!-- Formulario para crear un nuevo mensaje -->
	<div class="modal fade in" id="nuevoMensajepryModal" tabindex="-1" role="dialog" aria-labelledby="nuevoMensajepryModalLabel" aria-hidden="true">
		<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
			<div class="modal-content">		
				<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
					<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Ingresa tu consulta</div>				
				</div>
				<form role="form" action="" method="POST" name="frmcreamensajepry" id="frmcreamensajepry" class="needs-validation">
					<div class="modal-body">
						<div class="row">							
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>										
										<textarea id="MEN_TextoConsulta" name="MEN_TextoConsulta" class="md-textarea form-control" rows="3" required></textarea>
										<span class="select-bar"></span>
										<label for="MEN_TextoConsulta" class="">Consulta</label>									
									</div>
								</div>
							</div>					
						</div>
					</div>				
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary btn-md waves-effect" id="btn_creamsjprycerrar" name="btn_creamsjprycerrar"><i class="fas fa-times"></i> Cerrar</button>
						<button type="button" class="btn btn-primary btn-md waves-effect" id="btn_creamsjpry" name="btn_creamsjpry"><i class="fas fa-paper-plane"></i> Enviar</button>
					</div>
					<input type="hidden" id="MEN_IdConsulta" value="" name="MEN_IdConsulta">
				</form>
			</div>
		</div>
	</div>
	<!-- Formulario para crear un nuevo mensaje -->

	<!-- Formulario pra responder a una consulta -->
	<div class="modal fade in" id="nuevaRespuestapryModal" tabindex="-1" role="dialog" aria-labelledby="nuevaRespuestapryModalLabel" aria-hidden="true">
		<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
			<div class="modal-content">		
				<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
					<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Ingresa tu respuesta</div>				
				</div>
				<form role="form" action="" method="POST" name="frmcrearespuestapry" id="frmcrearespuestapry" class="needs-validation">
					<div class="modal-body">
						<div class="row">					
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<div class="md-form">
									<div class="error-message">								
										<i class="fas fa-comment prefix"></i>										
										<textarea id="MEN_TextoRespuesta" name="MEN_TextoRespuesta" class="md-textarea form-control" rows="3" required></textarea>
										<span class="select-bar"></span>
										<label for="MEN_TextoRespuesta" class="">Respuesta</label>
									</div>						
								</div>	
							</div>					
						</div>
					</div>				
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary btn-md waves-effect" id="btn_respuestaprycerrar" name="btn_respuestaprycerrar"><i class="fas fa-times"></i> Cerrar</button>
						<button type="button" id="btn_respuestapry" name="btn_respuestapry" class="btn btn-primary btn-md waves-effect"><i class="fas fa-paper-plane"></i> Responder</button>
					</div>
					<input type="hidden" id="MEN_IdRespuesta" value="" name="MEN_IdRespuesta">					
				</form>
			</div>
		</div>
	</div>
	<!-- Formulario pra responder a una consulta -->

<script>    
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});
	
	$(document).ready(function() {				
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var s  = String.fromCharCode(47);
		var b  = String.fromCharCode(92);						
				
		var mensajespryTable;		
		var disabled={};
		var iTermGPACounter = 1;	
		$("#mensajespryModal").on('show.bs.modal', function(e){					
			
		})		
					
		function loadTablemensajespry(){			
			if($.fn.DataTable.isDataTable( "#tbl-mensajespry")){				
				if(mensajespryTable!=undefined){
					mensajespryTable.destroy();
				}else{
					$('#tbl-mensajespry').dataTable().fnClearTable();
    				$('#tbl-mensajespry').dataTable().fnDestroy();
				}
			}	
			mensajespryTable = $('#tbl-mensajespry').DataTable({
				lengthMenu: [ 5,10,20 ],
				ajax:{
					url:"/mensajes-proyectos",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>}
				},				
				"columnDefs": <%=columnsDefsmensajespry%>,
				"order": [[0,"desc"]]
				
			});	
		}								
		
		$("#mensajespryModal").on('shown.bs.modal', function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();									
			
			$(document).off('focusin.modal');
			$("body").addClass("modal-open");
			loadTablemensajespry();			
			exportTable();
		});					
		
		$("#mensajespryModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("body").removeClass("modal-open")
			$("#frmadecuacion").css("height","0");			
			$('#container-table-mensajespry').animate({
				height: $('#container-table-mensajespry').get(0).scrollHeight
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
		
		$("#mensajespryModal").on("click", ".verrespry", function(e) {
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var tr = $(this).closest('tr');
			var row = mensajespryTable.row(tr);			
			var id=$(this).data("id");			
			
			$(this).toggleClass('openmenu');			
			
			if (row.child.isShown()) {				  
			  $('div.slider', row.child()).slideUp( function () {
				 row.child.hide();
				 tr.removeClass('shown');				 
			  } );
			  $(this).parent().find(".vermod").toggleClass("collapsed")			  
			} else {
			  // Open this row			  
			  row.child(formatRespuesta(row.data(),"tbl-menpryRES_" + iTermGPACounter )).show();
			  tr.addClass('shown');
			  $('div.slider', row.child()).slideDown();			  
			  $(this).parent().find(".vermod").toggleClass("collapsed")				 			  

			  iTermGPACounter += 1;						 
			}			
	  	});
		
		$("body").on("click", ".resppry",function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			$("#nuevaRespuestapryModal").modal("show");
			$("#MEN_IdRespuesta").val($(this).data("id"));			
		});
		
		$("body").on("click", "#btn_respuestaprycerrar",function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("#nuevaRespuestapryModal").modal("hide")
		});
		
		
		$("body").on("click", "#btn_respuestapry",function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frmcrearespuestapry");						
			if($("#frmcrearespuestapry").valid()){
				var data = {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',MEN_Id:$("#MEN_IdRespuesta").val(),MEN_Texto:$("#MEN_TextoRespuesta").val()};
				//console.log(data)
				$.ajax( {
					type:'POST',
					url: '/enviar-respuestas-proyectos',
					data: data,
					dataType: "json",
					success: function ( data ) {
						if(data.state=200){
							$("#frmcrearespuestapry")[0].reset();
							mensajespryTable.ajax.reload();
							$("#nuevaRespuestapryModal").modal("hide")
							Toast.fire({
							  icon: 'success',
							  title: 'Respuesta enviada exitosamente.'
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Envío de respuesta Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Envío de respuesta Fallido'							
						});
					}
				});
											
			}
			
		})
		
		$("body").on("click", "#btn_creamsjpry",function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			formValidate("#frmcreamensajepry");						
			if($("#frmcreamensajepry").valid()){
				var data = {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',MEN_Id:$("#MEN_IdConsulta").val(),MEN_Texto:$("#MEN_TextoConsulta").val()};
				//console.log(data)
				$.ajax( {
					type:'POST',
					url: '/enviar-consulta-proyectos',
					data: data,
					dataType: "json",
					success: function ( data ) {
						if(data.state=200){
							$("#frmcreamensajepry")[0].reset();
							mensajespryTable.ajax.reload();
							$("#nuevoMensajepryModal").modal("hide")
							Toast.fire({
							  icon: 'success',
							  title: 'Consulta enviada exitosamente.'
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Envío de consulta Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){				
						swalWithBootstrapButtons.fire({
							icon:'error',
							title:'Envío de consulta Fallido'							
						});
					}
				});
											
			}
			
		})
		
		$("body").on("click", "#btn_creamsjprycerrar",function(e){			
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			$("#nuevoMensajepryModal").modal("hide")
		});					
		$("#nuevoMensajepryModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			mensajespryTable.ajax.reload();			
		})
		
		$("#nuevaRespuestapryModal").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
		})
		$("#nuevoMensajepryModal").on('shown.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();															
		})
		
		$("body").on("click", "#btn_creaconsultapry",function(e){		
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			$("#nuevoMensajepryModal").modal("show");
			$("#MEN_IdConsulta").val($(this).data("id"));			
		});
		
		
		
		$("#nuevaRespuestapryModal").on('hidden.bs.modal', function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			mensajespryTable.ajax.reload();
		})
		
		function formatRespuesta(rowData,table_id) {	
			var div = $('<div class="slider"/>')
				.addClass( 'loading' )
				.text( 'Loading...' );
			var data = {MEN_Id: rowData[0],table: table_id,PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>'};			
			$.ajax( {
				type:'POST',
				url: '/ver-respuestas-proyectos',
				data: data,
				success: function ( data ) {					
					div
						.html( data )
						.removeClass( 'loading' );
						if ( $.fn.DataTable.isDataTable( "#" + table_id) ) {
							$("#" + table_id).dataTable().fnDestroy();
						}
						$("#" + table_id).DataTable({								
							lengthMenu: [ 4, 6, 10 ],
							order: [[ 0, 'desc' ]]
						});											
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				

				}
			} );

			return div;
		}								
		
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
		
		
		$("body").append("<button id='btn_modalmensajespry' name='btn_modalmensajespry' style='visibility:hidden;width:0;height:0'></button>");
		$("#btn_modalmensajespry").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			$("#mensajespryModal").modal("show");
			$("body").addClass("modal-open");
				
		});
		$("#btn_modalmensajespry").click();		
		$("#btn_modalmensajespry").remove();
	})
</script>