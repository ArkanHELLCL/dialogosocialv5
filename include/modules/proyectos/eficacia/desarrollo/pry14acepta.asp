<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%
	LIN_Id=request("LIN_Id")
	mode=request("mode")
	PRY_Id=request("PRY_Id")
	PRY_Hito=3
	
	disabled="required"
	if(PRY_Id="") then
		PRY_Id=0
	end if
	if mode="add" then
		mode="mod"		
	end if
	if mode="mod" then
		modo=2
		txtBoton="<i class='fas fa-download'></i> Grabar"
		btnColor="btn-warning"		
		action="/mod-14-h3-acepta"		
	end if
	if(session("ds5_usrperfil")=3 or session("ds5_usrperfil")=4 or session("ds5_usrperfil")=5) then	'Ejecutor, Auditor y Administrativo
		mode="vis"
		modo=4
		disabled="readonly disabled"				
	end if	
	if mode="vis" then
		modo=4
		disabled="readonly disabled"
		txtBotonS="<i class='fas fa-forward'></i>"
		btnColorS="btn-secondary"
		
		txtBotonA="<i class='fas fa-backward'></i>"
		btnColorA="btn-secondary"
		
	end if
				
	set cnn = Server.CreateObject("ADODB.Connection")
	on error resume next	
	cnn.open session("DSN_DialogoSocialv5")
	if cnn.Errors.Count > 0 then 
	   ErrMsg = cnn.Errors(0).description	   
	   cnn.close
	   response.Write("503/@/Error Conexión:" & ErrMsg)
	   response.End() 			   
	end if
	
	lblClass=""
	if(mode="mod" or mode="vis") then		
		sql="exec spProyecto_Consultar " & PRY_Id
		set rs = cnn.Execute(sql)
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503/@/Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if
		if not rs.eof then	
			PRY_Identificador=rs("PRY_Identificador")
			LIN_Id=rs("LIN_Id")			
		else
			response.Write("503/@/Error Conexión:")
	   		response.End() 
		end if		
	end if
	
	rs.close
	response.write("200/@/")	
	'response.write(LIN_Id & "-" & mode & "-" & PRY_Id)
	'response.end
	if(mode="mod") then%>
		<h5>Aceptar/Rechazar</h5>
		<h6>Aceptar o Rechazar Informe DESARROLLO</h6>
		<div style="padding-top:50px;"></div>
			<form role="form" action="<%=action%>" method="POST" name="frm14acepta" id="frm14acepta" class="needs-validation">
				<div class="row align-items-center">
					<div class="col-sm-12 col-md-6 col-lg-6" style="text-align:center;height:100%">
						<button type="button" class="btn btn-success btn-lg" id="btn_frm14acepta_1" name="btn_frm14acepta_1" value="enviar"><i class="fas fa-thumbs-up"></i> ACEPTAR</button>
						<button type="button" class="btn btn-danger btn-lg" id="btn_frm14acepta_2" name="btn_frm14acepta_2" value="enviar" data-toggle="modal" data-target="#modalRechaza"><i class="fas fa-thumbs-down"></i> RECHAZAR</button>
					</div>				
					<div class="col-sm-12 col-md-6 col-lg-6">
						<blockquote>
							<p>
								Después de haber revisado y corregido la información en los pasos anteriores, es necesario aceptar el informe "Desarrollo", con el fin informar al ejecutor este hecho y asi poder continuar con el ingreso de la información del siguiente informe.
							</p>
							<p>
								Presionando el botón "ACEPTAR", se cambiará el estado del proyecto actual y se enviará a los perfiles asociados el requerimiento en su nueva etapa.
							</p>
							<p>
								Al rechazar el informe se liberará el HITO DESARROLLO para que el ejecutor pueda subsanar las observaciones que deben ser ingresadas un vez presionado el botón "RECHAZAR"
							</p>
						</blockquote>                                		                                                                    
					</div>                               		                                    
				</div>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">			
			</form>			
		</div><%
	else
		if(session("ds5_usrperfil"))=3 then
			perfil = "Ejecutor"
		end if
		if(session("ds5_usrperfil"))=4 then
			perfil="Auditor"
		end if
		if(session("ds5_usrperfil"))=5 then
			perfil="Administrativo"
		end if%>
		<h5>Revisión de Informe</h5>
		<h6>Informe DESARROLLO en proceso de revisión</h6>
		<div style="padding-top:50px;"></div>
			<form role="form" action="" method="POST" name="" id="" class="needs-validation">
				<div class="row align-items-center">
					<div class="col-sm-12 col-md-2 col-lg-2">
						<i class="fas fa-info fa-9x text-primary"></i>
					</div>
					<div class="col-sm-12 col-md-10 col-lg-10">
						<blockquote>
							<p>
								Estimado <%=perfil%>, actualmente el informe DESARROLLO se encuentra en proceso de revisión. En este período el revisor del proyecto podría enviarle algunas solicitudes de adecuaciones requeridas para completar el informe y asi proceder a la aceptación del mismo.
							</p>
							<p>
								Para revisar estas observaciones solo debe ingresar en el menú de Adecuaciones que se encuentra situado en la parte superior izquierda de esta pantalla.
							</p>
						</blockquote>                                		                                                                    
					</div>                               		                                    
				</div>				
			</form>			
		</div><%
	end if%>
<!-- Formulario para rechazar el informe Desarrollo -->
<div class="modal fade in" id="modalRechaza" tabindex="-1" role="dialog" aria-labelledby="modalRechazaLabel" aria-hidden="true">
	<div class="modal-dialog cascading-modal narrower modal-lg" role="document">  		
    	<div class="modal-content">		
      		<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
        		<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-comments"></i> Ingresa el motivo del rechazo</div>				
      		</div>
			<form role="form" action="/mod-14-h3-rechaza" method="POST" name="frmrechazainicio" id="frmrechazainicio" class="needs-validation">
				<div class="modal-body">
					<div class="row">
						<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
							<div class="md-form input-with-post-icon">
								<div class="error-message">								
									<i class="fas fa-comment prefix"></i>
									<input type="text" id="MEN_TextoRechazo" name="MEN_TextoRechazo" class="form-control" required="">
									<span class="select-bar"></span>
									<label for="MEN_TextoRechazo" class="">Motivo de Rechazo:</label>									
								</div>
							</div>
						</div>								
					</div>
				</div>				
		  		<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
					<button type="button" class="btn btn-danger btn-md waves-effect" id="btn_rechazainicio" name="btn_rechazainicio"><i class="fas fa-times"></i> Rechazar</button>
				</div>
				<input type="hidden" id="PRY_Id" name="PRY_Id" value="<%=PRY_Id%>">
				<input type="hidden" id="PRY_Identificador" name="PRY_Identificador" value="<%=PRY_Identificador%>">
			</form>
		</div>
	</div>
</div>
<!-- Formulario para rechazar el informe inicio -->

<script>
	$(document).ready(function() {	
		var ss = String.fromCharCode(47) + String.fromCharCode(47);
		var sas = String.fromCharCode(47) + String.fromCharCode(64) + String.fromCharCode(47);
		var bb = String.fromCharCode(92) + String.fromCharCode(92);		

		setInterval(function(){
			$("h5").slideDown("slow",function(){
				$("h6").slideDown("slow");
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
		
		$("#btn_frm14acepta_1").click(function(){
			$.ajax({
				type: 'POST',			
				url: '/lista-estado-documento',
				data: {PRY_Id:<%=PRY_Id%>,PRY_Identificador:'<%=PRY_Identificador%>',PRY_Hito:<%=PRY_Hito%>},
				dataType: "json",
				success: function(data) {						
					if(data.state=="200"){						
						var VPR_Total = data.VPR_Total
						var VPR_EstadoAprobadoTotal = data.VPR_EstadoAprobadoTotal

						if(VPR_EstadoAprobadoTotal<VPR_Total){
							swalWithBootstrapButtons.fire({
								icon:'error',								
								title: 'Documentos faltantes.',						
								text:'Antes de aceptar el informe Desarrollo, debes tener APROBADOS todos los documentos solicitados en el ítem "Documentos"'
							});	
						}else{
							swalWithBootstrapButtons.fire({
							  title: 'Confirmación de Aceptación',
							  text: '¿Estas seguro de querer aceptar el informe "Desarrollo" para dar comienzo al ingreso del informe Final?',
							  icon: 'success',
							  showCancelButton: true,
							  confirmButtonColor: '#3085d6',
							  cancelButtonColor: '#d33',
							  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Aceptar Informe!',
							  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, aún no'
							}).then((result) => {
							  if (result.value) {			  					
								$.ajax({
									type: 'POST',			
									url: $("#frm14acepta").attr("action"),
									data: $("#frm14acepta").serialize(),
									dataType: "json",
									success: function(data) {						
										if(data.state=="200"){
											$("#frm14acepta")[0].reset();
											Toast.fire({
											  icon: 'success',
											  title: 'Aceptación del Informe realizada con éxito.'
											});
											//Creación del informe
											wrk_informes('/prt-informeavancesrecuperacion','informeavancesrecuperacion.pdf',<%=PRY_Id%>,'<%=PRY_Identificador%>','/mnu-14',<%=session("ds5_usrid")%>,'<%=session("ds5_usrtoken")%>');

											var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>};
											$.ajax( {
												type:'POST',					
												url: '/mnu-14',
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
												title: 'Ups!, no pude aceptar el Hito',					
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
							})							
						}
					}
				}
			})
		})
										
		
		$("#btn_rechazainicio").click(function(){
		
			formValidate("#frmrechazainicio");
			if($("#frmrechazainicio").valid()){	
				$("#modalRechaza").modal("hide");
				swalWithBootstrapButtons.fire({
				  title: 'Confirmación de Rechazo',
				  text: '¿Estas seguro de querer rechazar el informe "Desarrollo" para liberar el HITO al ejecutor?',
				  icon: 'error',
				  showCancelButton: true,
				  confirmButtonColor: '#3085d6',
				  cancelButtonColor: '#d33',
				  confirmButtonText: '<i class="fas fa-thumbs-up"></i> Si, Rechazar Informe!',
				  cancelButtonText: '<i class="fas fa-thumbs-down"></i> No, aún no'
				}).then((result) => {
				  if (result.value) {			  	
					$.ajax({
						type: 'POST',			
						url: $("#frmrechazainicio").attr("action"),
						data: $("#frmrechazainicio").serialize(),
						dataType: "json",
						success: function(data) {												
							if(data.state=="200"){
								$("#frmrechazainicio")[0].reset();								
								Toast.fire({
								  icon: 'success',
								  title: 'Rechazo del informe se ha realizado con éxito.'
								});
								var data   = {modo:<%=modo%>,PRY_Id:<%=PRY_Id%>,LIN_Id:<%=LIN_Id%>};
								$.ajax( {
									type:'POST',					
									url: '/mnu-14',
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
									title: 'Ups!, no pude rechazar la aceptación del Hito',					
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
				 })
			}
		})
		
	});
</script>