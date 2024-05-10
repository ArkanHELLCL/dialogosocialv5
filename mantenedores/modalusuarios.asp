<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	USR_Id=request("USR_Id")
	USR_Identificador=request("USR_Identificador")
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmusuarios="frmusuarios"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-usuarios"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-usuarios"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmusuarios=""
		disabled="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")<>1) then
		ds = "disabled"
		lblSelect = "active"
	else
		if(mode="add") then
			ds="required"
		else
			ds = "required"		
			lblSelect = ""
		end if
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
	
	if(mode="mod") then
		set rs = cnn.Execute("exec spUsuario_Consultar " & USR_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			USR_Identificador				= rs("USR_Identificador")
			PER_Id							= rs("PER_Id")
			'PER_Nombre						= rs("PER_Nombre")
			USR_Estado         				= rs("USR_Estado")
			USR_Usuario 					= rs("USR_Usuario")
			USR_Telefono					= rs("USR_Telefono")
			USR_Direccion					= rs("USR_Direccion")
			USR_Mail						= rs("USR_Mail")			
			USR_Nombre						= rs("USR_Nombre")
			USR_Apellido					= rs("USR_Apellido")
			Rut								= rs("USR_Rut")
			USR_Dv							= rs("USR_Dv")
			USR_NombreInstitucion           = rs("USR_NombreInstitucion")
			SEX_Id                          = rs("SEX_Id")
			COM_Id                          = rs("COM_Id")
			COM_Nombre                      = rs("COM_Nombre")
			REG_Id                          = rs("REG_Id")
			REG_Nombre                      = rs("REG_Nombre")
			USR_LDAP						= rs("USR_LDAP")
			DEP_Id							= rs("DEP_Id")
			EME_Id							= rs("EME_Id")
			EME_Nombre						= rs("EME_Nombre")
		end if
		if SEX_Id=1 then
		  	Sexo="fa-venus"
	    else
			if SEX_Id=2 then
				Sexo="fa-mars"
			else
				Sexo="fa-venus-mars"
			end if
	    end if
		
		USR_Rut=Rut & USR_Dv
		rs.Close		
	else
		REG_Id=0
		COM_Id=0
		SEX_Id=0
		PER_Id=0
		USR_Estado=1	'Activado
		USR_LDAP=0
		DEP_Id=0
	end if
	
	if(USR_LDAP=1) then
		LDAP="checked"
	else
		LDAP=""
	end if
	if(USR_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>	
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Usuarios</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmusuarios" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmusuarios%>" id="<%=frmusuarios%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(USR_Usuario<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="USR_Usuario" name="USR_Usuario" class="form-control" <%=disabled%> value="<%=USR_Usuario%>">
											<span class="select-bar"></span>
											<label for="USR_Usuario" class="<%=lblClass%>">Usuario</label>
										</div>
									</div><%
									if (session("ds5_usrperfil")=1) then%>
										<i class="fas fa-search search usrSearch"></i><%
									end if%>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-user input-prefix"></i><%
											if(USR_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="USR_Nombre" name="USR_Nombre" class="form-control" <%=disabled%> value="<%=USR_Nombre%>">
											<span class="select-bar"></span>
											<label for="USR_Nombre" class="<%=lblClass%>">Nombres</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-user input-prefix"></i><%
											if(USR_Apellido<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="USR_Apellido" name="USR_Apellido" class="form-control" <%=disabled%> value="<%=USR_Apellido%>">
											<span class="select-bar"></span>
											<label for="USR_Apellido" class="<%=lblClass%>">Apellidos</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-id-card input-prefix"></i><%
											if(USR_Rut<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="USR_Rut" name="USR_Rut" class="form-control" <%=disabled%> value="<%=USR_Rut%>">
											<span class="select-bar"></span>
											<label for="USR_Rut" class="<%=lblClass%>">Rut</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-envelope input-prefix"></i><%
											if(USR_Mail<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="email" id="USR_Mail" name="USR_Mail" class="form-control" <%=disabled%> value="<%=USR_Mail%>">
											<span class="select-bar"></span>
											<label for="USR_Mail" class="<%=lblClass%>">Email</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select DEP_Id">
												<select name="DEP_Id" id="DEP_Id" class="select-text form-control" <%=ds%>><%
													if((DEP_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spDepartamento_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(DEP_Id = rs("DEP_Id")) then%>
															<option value="<%=rs("DEP_Id")%>" selected><%=rs("DEP_Descripcion")%></option><%
														else%>
															<option value="<%=rs("DEP_Id")%>"><%=rs("DEP_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Departamento</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">																																
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="REG_Id" id="REG_Id" class="select-text form-control" <%=ds%>><%
													if((REG_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spRegion_Listar")
													on error resume next					
													do While Not rs.eof
														if(REG_Id = rs("REG_Id")) then%>
															<option value="<%=rs("REG_Id")%>" selected><%=rs("REG_Nombre")%></option><%
														else%>
															<option value="<%=rs("REG_Id")%>"><%=rs("REG_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Región</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="COM_Id" id="COM_Id" class="select-text form-control" <%=ds%>><%
													if((COM_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spComuna_Listar " & REG_Id)
													on error resume next					
													do While Not rs.eof
														if(COM_Id = rs("COM_Id")) then%>
															<option value="<%=rs("COM_Id")%>" selected><%=rs("COM_Nombre")%></option><%
														else%>
															<option value="<%=rs("COM_Id")%>"><%=rs("COM_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Comuna</label>
											</div>
										</div>
									</div>								
								</div>
							</div>
							
							<div class="row">																								
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-map-marker-alt input-prefix"></i><%
											if(USR_Direccion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="USR_Direccion" name="USR_Direccion" class="form-control" <%=disabled%> value="<%=USR_Direccion%>">
											<span class="select-bar"></span>
											<label for="USR_Direccion" class="<%=lblClass%>">Dirección</label>
										</div>
									</div>
								</div>											
							
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-mobile input-prefix"></i><%
											if(USR_Telefono<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="USR_Telefono" name="USR_Telefono" class="form-control" <%=disabled%> value="<%=USR_Telefono%>">
											<span class="select-bar"></span>
											<label for="USR_Telefono" class="<%=lblClass%>">Telefono</label>
										</div>
									</div>
								</div>	
								
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="SEX_Id" id="SEX_Id" class="validate select-text form-control" <%=ds%>>
													<option value="" disabled selected></option><%																	
													set rs = cnn.Execute("exec spSexo_listar")
													on error resume next					
													do While Not rs.eof
														if(SEX_Id=rs("SEX_Id")) then%>
															<option value="<%=rs("SEX_Id")%>" selected><%=rs("SEX_Descripcion")%></option><%
														else%>
															<option value="<%=rs("SEX_Id")%>"><%=rs("SEX_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>									
												<i class="fas <%=sexo%> input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Género</label>
											</div>
										</div>	
									</div>
								</div>								
							</div>
							<div class="row align-items-center">																
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="PER_Id" id="PER_Id" class="validate select-text form-control" <%=ds%>>
													<option value="" disabled selected></option><%																	
													set rs = cnn.Execute("exec spPerfil_listar -1")
													on error resume next					
													do While Not rs.eof
														if(PER_Id=rs("PER_Id")) then%>
															<option value="<%=rs("PER_Id")%>" selected><%=rs("PER_Nombre")%></option><%
														else%>
															<option value="<%=rs("PER_Id")%>"><%=rs("PER_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>									
												<i class="fas fa-user-tie input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Perfil</label>
											</div>
										</div>	
									</div>
								</div>
							
								
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="USR_Reset" class="switch__input">
										<label for="USR_Reset" class="switch__label">Resetear Clave</label>
									</div>
								</div>														
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch LDAP">
										<input type="checkbox" id="USR_LDAP" class="switch__input" <%=LDAP%>>
										<label for="USR_LDAP" class="switch__label">LDAP</label>
									</div>
								</div>								
							</div>
							
							<div class="row align-items-center">								
								<div class="col-sm-12 col-md-12 col-lg-10">
								<div id="EMEJ">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="EME_Id" id="EME_Id" class="validate select-text form-control" <%=ds%>>
													<option value="" disabled selected></option><%																	
													set rs = cnn.Execute("exec spEmpresaEjecutora_listar -1")
													on error resume next					
													do While Not rs.eof
														if(EME_Id=rs("EME_Id")) then%>
															<option value="<%=rs("EME_Id")%>" selected><%=rs("EME_Nombre")%></option><%
														else%>
															<option value="<%=rs("EME_Id")%>"><%=rs("EME_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>									
												<i class="fas fa-building input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Ejecutor</label>
											</div>
										</div>	
									</div>
								</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="USR_Estado" class="switch__input" <%=Estado%>>
										<label for="USR_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="USR_Id" name="USR_Id" value="<%=USR_Id%>">
								<input type="hidden" id="USR_Identificador" name="USR_Identificador" value="<%=USR_Identificador%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmusuarios-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmusuarios" name="btn_frmusuarios"><%=typeFrm%></button>
					</div><%
				end if%>

				<div style="float:right;" class="btn-group" role="group" aria-label="">					
					<button type="button" class="btn btn-secondary btn-md waves-effect" data-dismiss="modal" data-toggle="tooltip" title="Salir"><i class="fas fa-sign-out-alt"></i> Salir</button>
				</div>					
			</div>		  
			<!--footer-->	
		</div>
	</div>

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
		var UsuarioLDAPTable;
		$('select#REG_Id').on('change',function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			buscaComuna();
		});
		var rut = ( function rut_ch(){
			$('#USR_Rut').Rut({
				format_on: 'keyup'				
			});
			
		})
		usrLDAP();
		rut();
		function usrLDAP(){
			var LDAP = $("#USR_LDAP").is(':checked');
			if(LDAP){				
				$("#USR_Reset").parent().slideUp();
			}else{				
				$("#USR_Reset").parent().slideDown();			
			}
		}
		$("#USR_LDAP").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			usrLDAP();			
		})
		emej();
		$("#PER_Id").on("change",function(){
			emej()
		})
		$("#USR_Rut").val($.Rut.formatear($("#USR_Rut").val(),true));				
		function emej(){
			if($("#PER_Id").val()==3){
				$("#EMEJ").show();
				$("#DEP_Id").val("");
				$(".DEP_Id").hide();
				$(".LDAP").hide();
				//$("#USR_NombreInstitucion").val("")
			}else{
				$("#EME_Id").val("");				
				$("#EMEJ").hide();				
				$(".DEP_Id").show();
				$(".LDAP").show();
			}
		}
		$('select#SEX_Id').on('change', function(e){				
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();			
			if($(this).val()==1){
				$(this).siblings("i").removeClass("fa-genderless");
				$(this).siblings("i").removeClass("fa-mars");
				$(this).siblings("i").removeClass("fa-venus-mars");
				$(this).siblings("i").addClass("fa-venus");					
			}else{
				if($(this).val()==2){
					$(this).siblings("i").removeClass("fa-genderless");
					$(this).siblings("i").removeClass("fa-venus");
					$(this).siblings("i").removeClass("fa-venus-mars");
					$(this).siblings("i").addClass("fa-mars");						
				}
			};				
		});	
		
		$("#btn_frmusuarios").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Usuario agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Usuario modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmusuarios");			
			if($("#frmusuarios").valid()){
				if($("#USR_LDAP").is(":checked")){
					var USR_LDAP = 1
				}else{
					var USR_LDAP = 0
				}
				
				if($("#USR_Estado").is(":checked")){
					var USR_Estado = 1
				}else{
					var USR_Estado = 0
				}
				
				if($("#USR_Reset").is(":checked")){
					var USR_Reset = 1
				}else{
					var USR_Reset = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmusuarios").attr("action"),
					data: $("#frmusuarios").serialize() + "&USR_LDAP=" + USR_LDAP + "&USR_Reset=" + USR_Reset + "&USR_Estado=" + USR_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmusuarios")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de usuario Fallido',
								text:data.message
							});
						}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown){						
						swalWithBootstrapButtons.fire({
							icon:'error',								
							title: 'Ups!, no pude cargar el menú del proyecto',					
						});				
					}
				})
			}
		})	
		
		function buscaComuna(){
			var region = $("#REG_Id").val();    	
			$.ajax({
				type: 'POST',			
				url: '/seleccionar-comunas',
				data: {REG_Id:region},
				success: function(data) {					
					$('#COM_Id').html(data);
					setInterval(blink('#COM_Id'), 2200);								
				}
			});
		}
		
		function tableUsuarioLDAP(){			
			var tables = $.fn.dataTable.fnTables(true);
			$(tables).each(function () {
				$(this).dataTable().fnDestroy();
			});			
			UsuarioLDAPTable = $('#tbl-usuariosldap').DataTable()
		}
		
		$("#usuariosModal").on("click",".usrSearch",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			ajax_icon_handling('load','Creando listado de usuarios LDAP','','');			
			$.ajax({
				type: 'POST',								
				url:'/lista-usuario-ldap',				
				success: function(data) {
					var param=data.split("/@/");			
					if(param[0]=="200"){				
						ajax_icon_handling(true,'Listado de usuarios LDAP creado.','',param[1]);
						$(document).off('focusin.bs.modal');
						$(".swal2-popup").css("width","60rem");						
						tableUsuarioLDAP();												
						$("#tbl-usuariosldap").on("click","tr.usrline",function(){
							$(this).find("td").each(function(e){
								if([e]<5){
									$($("#usuariosModal input")[e]).val(this.innerText)
									$($("#usuariosModal input")[e]).siblings("label").addClass("active")
								}else{
									var DEP_Descripcion = this.innerText;									
									$.ajax({
										type: 'POST',								
										url:'/lista-departamento-por-nombre',
										datatype:'json',
										data:{DEP_Descripcion:DEP_Descripcion},
										success: function(data) {
											var result = JSON.parse((data))
											$("#DEP_Id").val(result.DEP_Id);								
										}
									})
								}
								$("#USR_Rut").val($.Rut.formatear($("#USR_Rut").val(),true));
							});																
							Swal.close();
							changedata=true;
							$(document).off('focusin.bs.modal');
						})
					}else{
						ajax_icon_handling(false,'No fue posible crear el listado de usuarios LDAP.','','');
					}						
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){				
					ajax_icon_handling(false,'No fue posible crear el listado de usuarios LDAP.','','');	
				},
				complete: function(){	
					/*Swal.fire({
						title: "successfully deleted",
						type: "success"
					})*/												
				}
			})

		});
	})
</script>