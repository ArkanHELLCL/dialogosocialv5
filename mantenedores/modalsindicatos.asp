<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	SIN_Id=request("SIN_Id")
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmsindicato="frmsindicato"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-sindicatos"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect="active"
				action="/modificar-sindicatos"
			else
				typeFrm=""
				button=""
				action=""
			end if
		end if
	else
		frmsindicato=""
		disabled="readonly"
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
		set rs = cnn.Execute("exec spSindicato_Consultar " & SIN_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			Rut				     = rs("SIN_Rut")
			SIN_Dv			     = rs("SIN_Dv")
			SIN_Id               = rs("SIN_Id")
			SIN_Nombre		     = rs("SIN_Nombre")
			SIN_Direccion	     = rs("SIN_Direccion")
			SIN_Telefono	     = rs("SIN_Telefono")
			ACE_Id			     = rs("ACE_Id")
			ACE_Nombre           = rs("ACE_Nombre")
			SIN_Mail		     = rs("SIN_Mail")
			RUB_Id               = rs("RUB_Id")
			RUB_Nombre           = rs("RUB_Nombre")
			SIN_DirPaginaWeb     = rs("SIN_DirPaginaWeb")
			SIN_NombrePresidente = rs("SIN_NombrePresidente")
			SIN_NumAsociados     = rs("SIN_NumAsociados")
			SIN_NumMujeres       = rs("SIN_NumMujeres")
			SIN_NumHombres       = rs("SIN_NumHombres")
			TOR_Id               = rs("TOR_Id")
		end if
		rs.Close
		SIN_Estado=1	'Activado
		SIN_Rut=Rut & SIN_Dv
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Sindicato</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmsindicato" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmsindicato%>" id="<%=frmsindicato%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(SIN_Rut<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="SIN_Rut" name="SIN_Rut" class="form-control" <%=disabled%> value="<%=SIN_Rut%>">
											<span class="select-bar"></span>
											<label for="SIN_Rut" class="<%=lblClass%>">RSU</label>
										</div>
									</div>
								</div>							
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-building input-prefix"></i><%
											if(SIN_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="SIN_Nombre" name="SIN_Nombre" class="form-control" <%=disabled%> value="<%=SIN_Nombre%>">
											<span class="select-bar"></span>
											<label for="SIN_Nombre" class="<%=lblClass%>">Nombre</label>
										</div>
									</div>
								</div>
							</div>
							
							<div class="row">							
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-mobile-alt input-prefix"></i><%
											if(SIN_telefono<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="SIN_telefono" name="SIN_telefono" class="form-control" <%=disabled%> value="<%=SIN_telefono%>">
											<span class="select-bar"></span>
											<label for="SIN_telefono" class="<%=lblClass%>">Teléfono</label>
										</div>
									</div>
								</div>				
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="ACE_Id" id="ACE_Id" class="select-text form-control" <%=ds%>><%
													if((ACE_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spAfiliacionCentral_Listar 1")
													on error resume next					
													do While Not rs.eof
														if(ACE_Id = rs("ACE_Id")) then%>
															<option value="<%=rs("ACE_Id")%>" selected><%=rs("ACE_Nombre")%></option><%
														else%>
															<option value="<%=rs("ACE_Id")%>"><%=rs("ACE_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-building input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Afiliación</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-envelope input-prefix"></i><%
											if(SIN_Mail<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="email" id="SIN_Mail" name="SIN_Mail" class="form-control calendario" <%=disabled%> value="<%=SIN_Mail%>">
											<span class="select-bar"></span>
											<label for="SIN_Mail" class="<%=lblClass%>">Email</label>
										</div>
									</div>
								</div>						
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="RUB_Id" id="RUB_Id" class="select-text form-control" <%=ds%>><%
													if(RUB_Id="") or (mode="add") then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spRubro_Listar 1")
													on error resume next					
													do While Not rs.eof
														if(RUB_Id = rs("RUB_Id")) then%>
															<option value="<%=rs("RUB_Id")%>" selected><%=rs("RUB_Nombre")%></option><%
														else%>
															<option value="<%=rs("RUB_Id")%>"><%=rs("RUB_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-building input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Rubro</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="TOR_Id" id="TOR_Id" class="select-text form-control" <%=ds%>><%
													if(TOR_Id="") or (mode="add") then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spTipoOrganizacion_Listar 1")
													on error resume next					
													do While Not rs.eof
														if(TOR_Id = rs("TOR_Id")) then%>
															<option value="<%=rs("TOR_Id")%>" selected><%=rs("TOR_Nombre")%></option><%
														else%>
															<option value="<%=rs("TOR_Id")%>"><%=rs("TOR_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-building input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Tipo de Organización</label>
											</div>
										</div>
									</div>
								</div>						
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-globe-americas input-prefix"></i><%
											if(SIN_DirPaginaWeb<>"") then
												lblClass="active"
											else
												lblClass=""
											end if
											if(mode="add" or mode="mod") then
												disabled=""
											end if%>
											<input type="url" id="SIN_DirPaginaWeb" name="SIN_DirPaginaWeb" class="form-control" <%=disabled%> value="<%=SIN_DirPaginaWeb%>">
											<span class="select-bar"></span>
											<label for="SIN_DirPaginaWeb" class="<%=lblClass%>">Dirección Página Web</label>
										</div>
									</div>
								</div>								
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="SIN_Id" name="SIN_Id" value="<%=SIN_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmsindicato-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Sindicato" id="btn_frmsindicato" name="btn_frmsindicato"><%=typeFrm%></button>
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
		$("#btn_frmsindicato").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';
			
			if(mode=="add"){
				var msg="Sindicato agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Sindicato modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmsindicato");			
			if($("#frmsindicato").valid()){
				$.ajax({
					type: 'POST',
					url: $("#frmsindicato").attr("action"),
					data: $("#frmsindicato").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmsindicato")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de sindicato Fallido',
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