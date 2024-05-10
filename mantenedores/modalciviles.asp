<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	CIV_Id=request("CIV_Id")	
	mode=request("mode")			
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmciviles="frmciviles"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-civiles"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-civiles"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmciviles=""
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
		set rs = cnn.Execute("exec spCiviles_Consultar " & CIV_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then	
			CIV_Id			= rs("CIV_Id")
			CIV_Nombre		= rs("CIV_Nombre")
			CIV_Direccion	= rs("CIV_Direccion")
			CIV_Telefono	= rs("CIV_Telefono")
			CIV_Rol			= rs("CIV_Rol")
			RUB_Id			= rs("RUB_Id")
			RUB_Nombre		= rs("RUB_Nombre")			
		end if		
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Organizacion Civil</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmciviles" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmciviles%>" id="<%=frmciviles%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(CIV_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="CIV_Nombre" name="CIV_Nombre" class="form-control" <%=disabled%> value="<%=CIV_Nombre%>">
											<span class="select-bar"></span>
											<label for="CIV_Nombre" class="<%=lblClass%>">Organización Civil</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(CIV_Direccion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="CIV_Direccion" name="CIV_Direccion" class="form-control" <%=disabled%> value="<%=CIV_Direccion%>">
											<span class="select-bar"></span>
											<label for="CIV_Direccion" class="<%=lblClass%>">Dirección</label>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(CIV_Telefono<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="CIV_Telefono" name="CIV_Telefono" class="form-control" <%=disabled%> value="<%=CIV_Telefono%>">
											<span class="select-bar"></span>
											<label for="CIV_Telefono" class="<%=lblClass%>">Teléfono</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(CIV_Rol<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="CIV_Rol" name="CIV_Rol" class="form-control" <%=disabled%> value="<%=CIV_Rol%>">
											<span class="select-bar"></span>
											<label for="CIV_Rol" class="<%=lblClass%>">ROL</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="RUB_Id" id="RUB_Id" class="select-text form-control" <%=ds%>><%
													if((RUB_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spRubro_Listar -1")
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
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Rubro</label>
											</div>
										</div>
									</div>
								</div>																
																								
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="CIV_Id" name="CIV_Id" value="<%=CIV_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmciviles-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Departamento" id="btn_frmciviles" name="btn_frmciviles"><%=typeFrm%></button>
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
		
		$("#btn_frmciviles").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Organización Civl agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Organización Civl modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmciviles");			
			if($("#frmciviles").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmciviles").attr("action"),
					data: $("#frmciviles").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmciviles")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Organización Civl Fallida',
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