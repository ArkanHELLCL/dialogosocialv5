<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	EME_Id=request("EME_Id")	
	mode=request("mode")			
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmempejecuitora="frmempejecuitora"
		disabled="required"
		disabledweb=""
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-empejecutora"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-empejecutora"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmempejecuitora=""
		disabled="readonly"
		disabledweb="readonly"
		calendario=""
		typeFrm=""
		button=""
	end if
	
	if (session("ds5_usrperfil")>2) then
		ds = "disabled"
		lblSelect = "active"
	else
		if(mode="add") then
			ds="required"
		else
			ds = ""		
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
		set rs = cnn.Execute("exec spEmpresaEjecutora_Consultar " & EME_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then	
			EME_Id				= rs("EME_Id")
			EME_Rol				= rs("EME_ROL")
			EME_Nombre			= rs("EME_Nombre")
			EME_Direccion		= rs("EME_Direccion")
			'REG_Nombre			= rs("REG_Nombre") 
			'COM_Nombre			= rs("COM_Nombre")
			REG_Id				= rs("REG_Id")
			COM_Id				= rs("COM_Id")
			EME_Telefono		= rs("EME_Telefono")
			EME_NombreContacto	= rs("EME_NombreContacto")
			EME_CargoContacto	= rs("EME_CargoContacto")
			EME_Mail			= rs("EME_Mail")
			EME_PaginaWeb		= rs("EME_PaginaWeb")
			EME_Estado			= rs("EME_Estado")
			TEJ_Id				= rs("TEJ_Id")
		end if
		if(TEJ_Id="" or IsNULL(TEJ_Id)) then
			TEJ_Id=-1
		end if
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Ejecutores</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmempejecuitora" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmempejecuitora%>" id="<%=frmempejecuitora%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-9 col-lg-9">
									<div class="md-form input-with-post-icon">
										<div class="error-message">	
											<i class="fas fa-building input-prefix"></i><%
											if(EME_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EME_Nombre" name="EME_Nombre" class="form-control" <%=disabled%> value="<%=EME_Nombre%>">
											<span class="select-bar"></span>
											<label for="EME_Nombre" class="<%=lblClass%>">Nombre Ejecutor</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-3 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-id-card input-prefix"></i><%
											if(EME_Rol<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EME_Rol" name="EME_Rol" class="form-control" <%=disabled%> value="<%=EME_Rol%>">
											<span class="select-bar"></span>
											<label for="EME_Rol" class="<%=lblClass%>">RUT</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-2 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="TEJ_Id" id="TEJ_Id" class="validate select-text form-control" <%=disabled%>><%
													if(TEJ_Id=-1) or (mode="add") then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec [spTipoEjecutor_Listar] -1")
													on error resume next					
													do While Not rs.eof
														if rs("TEJ_Id")=TEJ_Id then%>
															<option value="<%=rs("TEJ_Id")%>" selected><%=rs("TEJ_Descripcion")%></option><%
														else%>
															<option value="<%=rs("TEJ_Id")%>"><%=rs("TEJ_Descripcion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>																			
												</select>
												<i class="fas fa-users-cog input-prefix"></i>
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Tipo Ejecutor</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-4 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="REG_Id" id="REG_Id" class="validate select-text form-control" <%=disabled%>><%
													if(mode="add") then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spRegion_Listar")
													on error resume next					
													do While Not rs.eof
														if rs("REG_Id")=REG_Id then%>
															<option value="<%=rs("REG_Id")%>" selected ><%=rs("REG_Nombre")%></option><%
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
								<div class="col-sm-12 col-md-4 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="COM_Id" id="COM_Id" class="validate select-text form-control" <%=disabled%>><%
													if(mode="mod" or mode="vis") then
														set rs = cnn.Execute("exec spComuna_Listar " & REG_Id)
														on error resume next					
														do While Not rs.eof
															if rs("COM_Id")=COM_Id then%>
																<option value="<%=rs("COM_Id")%>" selected><%=rs("COM_Nombre")%></option><%
															else%>
																<option value="<%=rs("COM_Id")%>"><%=rs("COM_Nombre")%></option><%
															end if
															rs.movenext						
														loop
														rs.Close
													else%>
														<option value="" disabled selected></option><%
													end if%>							
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
								<div class="col-sm-12 col-md-12 col-lg-12">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-home input-prefix"></i><%
											if(EME_Direccion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EME_Direccion" name="EME_Direccion" class="form-control" <%=disabled%> value="<%=EME_Direccion%>">
											<span class="select-bar"></span>
											<label for="EME_Direccion" class="<%=lblClass%>">Dirección</label>
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-2 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-mobile-alt input-prefix"></i><%
											if(EME_Telefono<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="EME_Telefono" name="EME_Telefono" class="form-control" <%=disabled%> value="<%=EME_Telefono%>">
											<span class="select-bar"></span>
											<label for="EME_Telefono" class="<%=lblClass%>">Teléfono</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-user input-prefix"></i><%
											if(EME_NombreContacto<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EME_NombreContacto" name="EME_NombreContacto" class="form-control" <%=disabled%> value="<%=EME_NombreContacto%>">
											<span class="select-bar"></span>
											<label for="EME_NombreContacto" class="<%=lblClass%>">Contácto</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-5 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-user-tie input-prefix"></i><%
											if(EME_CargoContacto<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EME_CargoContacto" name="EME_CargoContacto" class="form-control" <%=disabled%> value="<%=EME_CargoContacto%>">
											<span class="select-bar"></span>
											<label for="EME_CargoContacto" class="<%=lblClass%>">Cargo</label>
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-envelope input-prefix"></i><%
											if(EME_Mail<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="email" id="EME_Mail" name="EME_Mail" class="form-control" <%=disabled%> value="<%=EME_Mail%>">
											<span class="select-bar"></span>
											<label for="EME_Mail" class="<%=lblClass%>">Mail</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-globe-americas input-prefix"></i><%
											if(EME_PaginaWeb<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="url" id="EME_PaginaWeb" name="EME_PaginaWeb" class="form-control" <%=disabledweb%> value="<%=EME_PaginaWeb%>">
											<span class="select-bar"></span>
											<label for="EME_PaginaWeb" class="<%=lblClass%>">Página Web</label>
										</div>
									</div>
								</div>								
							</div>
							<%
							if(mode="mod") then%>
								<input type="hidden" id="EME_Id" name="EME_Id" value="<%=EME_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmempejecuitora-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Empresa Ejecutora" id="btn_frmempejecuitora" name="btn_frmempejecuitora"><%=typeFrm%></button>
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
		
		$('select#REG_Id').on('change',function(){
			var region = $(this).val();    	
			$.ajax({
				type: 'POST',			
				url: '/seleccionar-comunas',
				data: {REG_Id:region},
				success: function(data) {					
					$('#COM_Id').html(data);
					setInterval(blink('#COM_Id'), 2200);								
				}
			});
		});	
		
		$("#btn_frmempejecuitora").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Empresa Ejecutora agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Empresa Ejecutora modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmempejecuitora");			
			if($("#frmempejecuitora").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmempejecuitora").attr("action"),
					data: $("#frmempejecuitora").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmempejecuitora")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Empresa Ejecutora Fallida',
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
	})
</script>