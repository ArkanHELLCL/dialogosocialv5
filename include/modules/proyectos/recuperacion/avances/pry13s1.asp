<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	PRY_Hito=2	
	LIN_Id=request("LIN_Id")
	'mode=request("mode")
	mode="mod"
	PRY_Id=request("PRY_Id")
	PRY_Identificador=request("PRY_Identificador")
	
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
	sql="exec spProyecto_Consultar " & PRY_Id
	set rs = cnn.Execute(sql)		
	on error resume next
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & sql)
	   response.End() 			   
	end if		
	if not rs.EOF then
		PRY_InformeConsensosEstado=rs("PRY_InformeConsensosEstado")
		PRY_InformeConsensosAceptado=rs("PRY_InformeConsensosAceptado")
		PRY_Step=rs("PRY_Step")
		PRY_Identificador=rs("PRY_Identificador")
	end if
	if(IsNULL(PRY_InformeConsensosEstado)) then
		PRY_InformeConsensosEstado=0
	end if
	if(IsNULL(PRY_InformeConsensosAceptado)) then
		PRY_InformeConsensosAceptado=0
	end if
	'if(PRY_InformeConsensosEstado=0) or session("ds5_usrperfil")=1 then
	if((PRY_InformeConsensosEstado=0) and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=3)) or ((PRY_InformeConsensosEstado=1 and PRY_InformeConsensosAceptado=0) and (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2)) then
		mode="mod"
	else
		mode="vis"
	end if
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="vis"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"		
		action="/mod-13-h2-s1"
		calendario="calendario"
		hora="hora"		
	end if
	if(session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Revisor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"		
		calendario=""
		hora=""
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		hora=""		
	end if					
	if(session("ds5_usrperfil")=2) then
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		calendario=""
		hora=""		
	end if
	lblClass=""	
	
	rs.close
	response.write("200/@/")	
%>
<form role="form" action="<%=action%>" method="POST" name="frm13s1" id="frm13s1" class="needs-validation">
	<h5>Informe Nro.: 2</h5>	
	<div class="row" style="padding-top:30px;">
		<div class="col-12" style="overflow: auto;">
			<table id="tbl-documentosava13" class="ts table table-striped table-bordered dataTable table-sm" data-id="documentosava13" data-page="true" data-selected="true" data-keys="1"> 
				<thead> 
					<tr> 
						<th style="width:10px;">Id</th>
						<th>Documento</th>								 
						<th>Subido</th>
						<th>Fecha</th>
						<th>Usuario</th>
						<th>Revisado</th>
						<th>Fecha</th>
						<th>Usuario</th>
						<th>Aprobado</th>
						<th>Fecha</th>
						<th>Usuario</th>
						<th>Rechazado</th>
						<th>Fecha</th>
						<th>Usuario</th>
						<th>Eliminado</th>
						<th>Fecha</th>
						<th>Usuario</th>
						<th style="width:100px;">Acciones</th>
					</tr> 
				</thead>					
				<tbody>					
				</tbody>
			</table>
		</div>
	</div>
	<div class="row">		
		<div class="footer"><%
			if(mode="mod" or mode="add") and (session("ds5_usrperfil")<>2) then%>		
				<button type="button" class="btn <%=btnColor%> btn-md waves-effect" id="btn_frm13s1" name="btn_frm13s1"><%=txtBoton%></button><%
			else%>
				<button type="button" class="btn <%=btnColorA%> btn-md waves-effect" id="btn_retroceder" name="btn_retroceder"><%=txtBotonA%></button>
				<button type="button" class="btn <%=btnColorS%> btn-md waves-effect" id="btn_avanzar" name="btn_avanzar"><%=txtBotonS%></button><%
			end if%>
		</div>		
	</div>
	<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>" />	
	<input type="hidden" id="PRY_Step" name="PRY_Step" value="<%=PRY_Step%>">
	<input type="hidden" id="Step" name="Step" value="1">
	<input type="hidden" id="PRY_Hito" name="PRY_Hito" value="<%=PRY_Hito%>">
	<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
</form>


<script>
	var ss = String.fromCharCode(47) + String.fromCharCode(47);
	var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
	var bb = String.fromCharCode(92) + String.fromCharCode(92);	
	var bab = String.fromCharCode(92) + String.fromCharCode(64) + String.fromCharCode(92);	
	
	var titani = setInterval(function(){				
		$("h5").slideDown("slow",function(){
			$("span.text-muted").slideDown("slow",function(){
				clearInterval(titani)
			});
		})
	},2300);
	
	$(function () {
		$('[data-toggle="tooltip"]').tooltip({
			trigger : 'hover'
		})
		$('[data-toggle="tooltip"]').on('click', function () {
			$(this).tooltip('hide')
		})		
	});	
	
	$(document).ready(function() {
		$("#btn_frm13s1").click(function(){
			formValidate("#frm13s1")
			if($("#frm13s1").valid()){				
				$.ajax({
					type: 'POST',			
					url: '/lista-estado-documento',
					data: {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PRY_Hito:$("#PRY_Hito").val()},
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){							
							var VPR_Total = data.VPR_Total
							var VPR_EstadoSubidoTotal = data.VPR_EstadoSubidoTotal
							
							if(VPR_EstadoSubidoTotal<VPR_Total){
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Documentos faltantes.',						
									text:'Antes de avanzar al cierre del hito AVANCES, debes tener arriba todos los documentos aqui solicitados'
								});	
							}else{								
								var bb = String.fromCharCode(92) + String.fromCharCode(92);
								$.ajax({
									type: 'POST',			
									url: '<%=action%>',
									data: $("#frm13s1").serialize(),
									dataType: "json",
									success: function(data) {										
										if(data.state=="200"){
											Toast.fire({
											  icon: 'success',
											  title: 'Documento(s) grabado(s) correctamente'
											});
											var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>,CRT_Step:parseInt($("#Step").val())+1,PRY_Hito:$("#PRY_Hito").val()};							
											$.ajax( {
												type:'POST',					
												url: '/mnu-13',
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

										}else{
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude grabar los datos del proyecto',					
												text:param[1]
											});
										}
									},
									error: function(XMLHttpRequest, textStatus, errorThrown){
										swalWithBootstrapButtons.fire({
											icon:'error',								
											title: 'Ups!, no pude cargar el menú del proyecto'							
										});
									}
								});

							}
							
							
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude contar los documentos cargados'							
							});
						}												
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto'							
						});

					}
				})				
			}
		})				
		var documentosTableAva13;		
		loadTableDocumentos();
        $('#tbl-documentosava13').css('width','100%')
		
		function loadTableDocumentos() {
			if($.fn.DataTable.isDataTable( "#tbl-documentosava13")){				
				$('#tbl-documentosava13').dataTable().fnClearTable();
    			$('#tbl-documentosava13').dataTable().fnDestroy();
			}	
			
			documentosTableAva13 = $('#tbl-documentosava13').DataTable({				
				lengthMenu: [ 10,15,20 ],
				ajax:{
					url:"/documentos-informe",
					type:"POST",
					data:{PRY_Id:<%=PRY_Id%>,PRY_Hito:$("#PRY_Hito").val(),mode:'<%=mode%>'},
					complete: function(data){						
						$("i.aprobado").parents('td').css("background", "rgba(92, 184, 92, .3)");
						$("i.revisado").parents('td').css("background", "rgba(240, 173, 78, .3)");
						$("i.rechazado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.eliminado").parents('td').css("background", "rgba(217, 83, 79, .3)");
						$("i.subido").parents('td').css("background", "rgba(91, 192, 222, .3)");
					}
				},				
				order: [
					[0, 'asc']
				],
				columnDefs:[
					{"targets": [ 4,7,10,13,16 ],"visible": false,"searchable": false},
					{"targets": [17],"width":"100px"},					
				],
				autoWidth: false
			});						
		}												
				
		$("#pry-content").on("click",".updocumentos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var VER_Corr = $(this).data("id");			
			swalWithBootstrapButtons.fire({
				icon:'info',
				title: 'Selecciona un archivo',
				showCancelButton: true,
				confirmButtonText: 'Subir',
				cancelButtonText: 'Cancelar',
				input: 'file',
				onBeforeOpen: () => {
					$(".swal2-file").attr("accept",'image/x-png,image/jpg,image/jpeg,image/gif,application/x-msmediaview,application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.wordprocessingml.document,,application/pdf, application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/msword,application/vnd.ms-powerpoint')
					$(".swal2-file").attr("multiple","multiple")
					$(".swal2-file").change(function () {
						var reader = new FileReader();
						reader.readAsDataURL(this.files[0]);
					});
				}
			}).then((file) => {
				if (file.value) {																
					var formData = new FormData();					
					var file = $('.swal2-file').prop('files');
					var fileName;
					var extFile;
					var fileOk = true;
					var sizerror=false;
					var sumsize=0;
					
					for (var i = 0; i < file.length; i++) {
						formData.append(file[i].name, file[i])
						fileName = file[i].name;
						extFile  = fileName.split('.').pop()
						if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="xls" || extFile=="xlsx" || extFile=="doc" || extFile=="docx" || extFile=="ppt" || extFile=="pptx" || extFile=="pdf"){
							
						}else{
							fileOk = false;
						};
						sumsize=sumsize+parseInt(file[i].size);
						if(parseInt(file[i].size)>parseInt(maxupload[maxsize].size)){
							sizerror=true;							
						};
					}
					if(sumsize>parseInt(maxupload[maxsize].size)){
						sizerror=true;							
					};
					if(fileOk){					
						formData.append("fileToUpload", file);
						formData.append("VER_Corr", VER_Corr);
						formData.append("PRY_Id", <%=PRY_Id%>);
						formData.append("PRY_Hito", $("#PRY_Hito").val());
						if(sizerror){
							Toast.fire({
								icon: 'error',
								title: maxupload[maxsize]['msg-toast']
							});	
						}else{
							$.ajax({
								url: "/subir-documentos",
								method: 'POST',					
								data:formData,
								enctype: 'multipart/form-data',
								cache: false,
								contentType: false,
								processData: false,
								dataType: "json",
								success: function (data) {								
									if(data.state==200){										
										documentosTableAva13.ajax.reload();
										Toast.fire({
										icon: 'success',
										title: 'Documento subido correctamente.'
										});									
									}else{
										swalWithBootstrapButtons.fire({
											icon:'error',
											title:'Subida Fallida',
											text:data.message
										});
									}
								},
								complete:function(data){								
								},
								error: function(){
									swalWithBootstrapButtons.fire({
										icon:'error',
										title:'Subida Fallida',
										text:data.message
									});
								}
							});
						}
					}else{
						Toast.fire({
						  icon: 'error',
						  title: 'Formato de archivo no válido!.'
						});
					}
				}
			})			
		})								
		
		$("#pry-content").on("click",".dodocumentos",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
						
			var VER_Corr = $(this).data("id")			
			ajax_icon_handling('load','Buscando verificadores','','');
			$.ajax({
				type: 'POST',								
				url:'/listar-documentos-informe',			
				data:{VER_Corr:VER_Corr,PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>',PRY_Hito:$("#PRY_Hito").val()},
				success: function(data) {
					var param=data.split(bb);			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de documentos creado.','',param[1]);
						$(".swal2-popup").css("width","60rem");
						loadtables("#tbl-historico");
						$(".arcalm").click(function(){
							var INF_Arc = $(this).data("file");
							var PRY_Hito=$("#PRY_Hito").val();
							var ALU_Rut;
							var data={PRY_Id:<%=PRY_Id%>, PRY_Identificador:'<%=PRY_Identificador%>', INF_Arc:INF_Arc, PRY_Hito:PRY_Hito, ALU_Rut:ALU_Rut,VER_Corr:VER_Corr};
							$.ajax({
								url: "/bajar-archivo",
								method: 'POST',
								data:data,
								xhrFields: {
									responseType: 'blob'
								},
								success: function (data) {

									var a = document.createElement('a');
									var url = window.URL.createObjectURL(data);
									a.href = url;
									a.download = INF_Arc;
									document.body.append(a);
									a.click();
									a.remove();
									window.URL.revokeObjectURL(url);
								}
							});			
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de documentos.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de documentos.','','');	
				},
				complete: function(){																		
				}
			})
		})
		
		$("#pry-content").on("click",".deldocumentos",function(e){
			e.preventDefault();
			e.stopPropagation();
			var VER_Corr = $(this).data("id");			
			var VPR_Corr = $(this).data("obj");			
			swalWithBootstrapButtons.fire({
			  title: '¿Estas seguro?',
			  text: "Esta acción eliminará el documento seleccionado",
			  icon: 'question',
			  showCancelButton: true,
			  confirmButtonColor: '#3085d6',
			  cancelButtonColor: '#d33',
			  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
			  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
			}).then((result) => {
			  if (result.value) {			
					$.ajax({
						type: 'POST',			
						url: '/elimina-documentos-informe',
						data: {PRY_Id:<%=PRY_Id%>, VER_Corr:VER_Corr, VPR_Corr:VPR_Corr,PRY_Hito:$("#PRY_Hito").val()},
						dataType: "json",
						success: function(data) {							
							if(data.state=="200"){
								documentosTableAva13.ajax.reload();
								Toast.fire({
								  icon: 'success',
								  title: 'Documentos eliminados correctamente'
								});									
							}else{
								swalWithBootstrapButtons.fire({
									icon:'error',								
									title: 'Ups!, no pude eliminar los datos del Documento',					
									text:param[1]
								});
							}
						},
						complete:function(data){													
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Ups!, no pude cargar el menú del proyecto'							
							});
						}
					});
				}
			})
			
		})
				
		$("#pry-content").on("click",".checkdocumentos",function(e){
			e.preventDefault();
			e.stopPropagation();
			var VER_Corr = $(this).data("id");			
			var VPR_Corr = $(this).data("obj");
			var VPR_EstadoAprobado;
			var VPR_EstadoRevisado;
			var estado;
			var msg;			
			$.ajax({
				type: 'POST',			
				url: '/consulta-estado-documento',
				data: {PRY_Id:<%=PRY_Id%>, VPR_Corr:VPR_Corr,PRY_Identificador:'<%=PRY_Identificador%>'},
				dataType: "json",
				success: function(data) {					
					if(data.state=="200"){											
						var estados = data.data
						VPR_EstadoRevisado = parseInt(estados[0].VPR_EstadoRevisado)
						VPR_EstadoAprobado = parseInt(estados[1].VPR_EstadoAprobado)
						
						if(VPR_EstadoRevisado==0){
							msg="Esta acción dejará en estado REVISADO el documento seleccionado"
							estado=1
						}else{
							msg="Esta acción dejará en estado NO REVISADO el documento seleccionado"
							estado=0
						}
						
						if(VPR_EstadoAprobado==0){
							swalWithBootstrapButtons.fire({
							  title: '¿Estas seguro?',
							  text: msg,
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
							}).then((result) => {
							  if (result.value) {			
									$.ajax({
										type: 'POST',			
										url: '/modifica-documentos-informe',
										data: {PRY_Id:<%=PRY_Id%>, VER_Corr:VER_Corr, VPR_Corr:VPR_Corr,PRY_Hito:$("#PRY_Hito").val(),PRY_Identificador:'<%=PRY_Identificador%>',VPR_EstadoRevisado:estado},
										dataType: "json",
										success: function(data) {										
											if(data.state=="200"){
												documentosTableAva13.ajax.reload();
												Toast.fire({
												  icon: 'success',
												  title: 'Exelente!',
												  text: 'Estado del documento actualizado correctamente'
												});													
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',								
													title: 'Ups!, no pude cambiar el estado del documento',					
													text:param[1]
												});
											}
										},
										complete:function(data){											
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude cargar el menú del proyecto'							
											});
										}
									});
								}
							})
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'ERROR',
								text: 'Debes quitar el estado APROBADO antes de quitar el REVISADO'
							});
						}
						
					}
				},
				complete:function(data){					
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar los datos del documento seleccionado'							
					});
				}
			});			
		})
		
		$("#pry-content").on("click",".acceptdocumentos",function(e){
			e.preventDefault();
			e.stopPropagation();
			var VER_Corr = $(this).data("id");			
			var VPR_Corr = $(this).data("obj");
			var VPR_EstadoRevisado;
			var VPR_EstadoAprobado;
			var estado;
			var msg;			
			$.ajax({
				type: 'POST',			
				url: '/consulta-estado-documento',
				data: {PRY_Id:<%=PRY_Id%>, VPR_Corr:VPR_Corr,PRY_Identificador:'<%=PRY_Identificador%>'},
				dataType: "json",
				success: function(data) {					
					if(data.state=="200"){											
						var estados = data.data
						VPR_EstadoRevisado = parseInt(estados[0].VPR_EstadoRevisado)
						VPR_EstadoAprobado = parseInt(estados[1].VPR_EstadoAprobado)
														
						if(VPR_EstadoAprobado==0){
							msg="Esta acción dejará en estado APROBADO el documento seleccionado"
							estado=1
						}else{
							msg="Esta acción dejará en estado NO APROBADO el documento seleccionado"
							estado=0
						}
						
						if(VPR_EstadoRevisado==1){						
							swalWithBootstrapButtons.fire({
							  title: '¿Estas seguro?',
							  text: msg,
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
							}).then((result) => {
							  if (result.value) {			
									$.ajax({
										type: 'POST',			
										url: '/modifica-documentos-informe',
										data: {PRY_Id:<%=PRY_Id%>, VER_Corr:VER_Corr, VPR_Corr:VPR_Corr,PRY_Hito:$("#PRY_Hito").val(),PRY_Identificador:'<%=PRY_Identificador%>',VPR_EstadoAprobado:estado},
										dataType: "json",
										success: function(data) {											
											if(data.state=="200"){
												documentosTableAva13.ajax.reload();
												Toast.fire({
												  icon: 'success',
												  title: 'Estado del documento actualizados correctamente'
												});												
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',								
													title: 'Ups!, no pude cambiar el estado del documento',					
													text:param[1]
												});
											}
										},
										complete:function(data){											
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude cargar el menú del proyecto'							
											});
										}
									});
								}
							})
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'ERROR',
								text:'Debes REVISAR el documento antes de APROBAR'
							});
						}
					}
				},
				complete:function(data){					
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar los datos del documento seleccionado'							
					});
				}
			});
			
		})				
		$("#pry-content").on("click",".rejectdocumentos",function(e){
			e.preventDefault();
			e.stopPropagation();
			var VER_Corr = $(this).data("id");			
			var VPR_Corr = $(this).data("obj");
			var VPR_EstadoRevisado;
			var VPR_EstadoAprobado;
			var estado;
			var msg;			
			$.ajax({
				type: 'POST',			
				url: '/consulta-estado-documento',
				data: {PRY_Id:<%=PRY_Id%>, VPR_Corr:VPR_Corr,PRY_Identificador:'<%=PRY_Identificador%>'},
				dataType: "json",
				success: function(data) {					
					if(data.state=="200"){											
						var estados = data.data
						VPR_EstadoRevisado = parseInt(estados[0].VPR_EstadoRevisado)
						VPR_EstadoAprobado = parseInt(estados[1].VPR_EstadoAprobado)
						VPR_EstadoRechazado = parseInt(estados[2].VPR_EstadoRechazado)
														
						if(VPR_EstadoRechazado==0){
							msg="Esta acción dejará en estado RECHAZADO el documento seleccionado"
							estado=1
						}else{
							msg="Esta acción dejará en estado NO RECHAZADO el documento seleccionado"
							estado=0
						}
						
						if(VPR_EstadoRevisado==1){
						
							swalWithBootstrapButtons.fire({
							  title: '¿Estas seguro?',
							  text: msg,
							  icon: 'question',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No'
							}).then((result) => {
							  if (result.value) {			
									$.ajax({
										type: 'POST',			
										url: '/modifica-documentos-informe',
										data: {PRY_Id:<%=PRY_Id%>, VER_Corr:VER_Corr, VPR_Corr:VPR_Corr,PRY_Hito:$("#PRY_Hito").val(),PRY_Identificador:'<%=PRY_Identificador%>',VPR_EstadoRechazado:estado},
										dataType: "json",
										success: function(data) {											
											if(data.state=="200"){
												documentosTableAva13.ajax.reload();
												Toast.fire({
												  icon: 'success',
												  title: 'Estado del documento actualizados correctamente'
												});												
											}else{
												swalWithBootstrapButtons.fire({
													icon:'error',								
													title: 'Ups!, no pude cambiar el estado del documento',					
													text:param[1]
												});
											}
										},
										complete:function(data){											
										},
										error: function(XMLHttpRequest, textStatus, errorThrown){
											swalWithBootstrapButtons.fire({
												icon:'error',								
												title: 'Ups!, no pude cargar el menú del proyecto'							
											});
										}
									});
								}
							})
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'ERROR',
								text:'Debes REVISAR el documento antes de RECHAZAR'
							});
						}
					}
				},
				complete:function(data){					
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar los datos del documento seleccionado'							
					});
				}
			});
			
		})		
	});	
	
	changeURL(<%=modo%>,$("#PRY_Hito").val(),$("#Step").val(),$("#PRY_Id").val())
	function changeURL(Modo,Hito,Step,PRY_Id){				
		var href = window.location.href;
		var newhref = href.substr(href.indexOf("/home")+6,href.length);
		var href_split = newhref.split("/")				
		
		if(href_split[1]=="modificar" || href_split[1]=="visualizar" || href_split[1]=="agregar"){
			if(Modo==2){
				href_split[1]="modificar";
				href_split[3]=PRY_Id;
			}
			if(Modo==4){
				href_split[1]="visualizar";
				href_split[3]=PRY_Id;
			}
			if(Modo!=1){
				href_split[4]=Hito;
				href_split[5]=Step;			
				var newurl="/home"
				$.each(href_split, function(i,e){
					newurl=newurl + "/" + e
				});
				window.history.replaceState(null, "", newurl);
			}
			cargabreadcrumb("/breadcrumbs","");
		}				
	};		
</script>