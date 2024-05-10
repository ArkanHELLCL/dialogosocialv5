<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	EMP_Id=request("EMP_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmempresas="frmempresas"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-empresas"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-empresas"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmempresas=""
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
		set rs = cnn.Execute("exec spEmpresa_Consultar " & EMP_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			EMP_Id              = rs("EMP_Id")
			EMP_Rol             = rs("EMP_Rol")
			EMP_Nombre 	        = rs("EMP_Nombre")
			EMP_Direccion       = rs("EMP_Direccion")
			EMP_telefono        = rs("EMP_telefono")
			EMP_NumTrabajadores = rs("EMP_NumTrabajadores")
			EMP_NumMujeres      = rs("EMP_NumMujeres")
			EMP_NumHombres      = rs("EMP_NumHombres")
			RUB_Id              = rs("RUB_Id")
			RUB_Nombre          = rs("RUB_Nombre")			
		end if		
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Empresa</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmempresas" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmempresas%>" id="<%=frmempresas%>" class="needs-validation">
							<div class="row">																							
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_Rol<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EMP_Rol" name="EMP_Rol" class="form-control" <%=disabled%> value="<%=EMP_Rol%>">
											<span class="select-bar"></span>
											<label for="EMP_Rol" class="<%=lblClass%>">ROL</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EMP_Nombre" name="EMP_Nombre" class="form-control" <%=disabled%> value="<%=EMP_Nombre%>">
											<span class="select-bar"></span>
											<label for="EMP_Nombre" class="<%=lblClass%>">Nombre</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-5">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_Direccion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="EMP_Direccion" name="EMP_Direccion" class="form-control" <%=disabled%> value="<%=EMP_Direccion%>">
											<span class="select-bar"></span>
											<label for="EMP_Direccion" class="<%=lblClass%>">Dirección</label>
										</div>
									</div>
								</div>								
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_telefono<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="EMP_telefono" name="EMP_telefono" class="form-control" <%=disabled%> value="<%=EMP_telefono%>">
											<span class="select-bar"></span>
											<label for="EMP_telefono" class="<%=lblClass%>">Teléfono</label>
										</div>
									</div>
								</div>	
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_NumTrabajadores<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="EMP_NumTrabajadores" name="EMP_NumTrabajadores" class="form-control" <%=disabled%> value="<%=EMP_NumTrabajadores%>">
											<span class="select-bar"></span>
											<label for="EMP_NumTrabajadores" class="<%=lblClass%>">N° Trabajadores</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_NumMujeres<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="EMP_NumMujeres" name="EMP_NumMujeres" class="form-control" <%=disabled%> value="<%=EMP_NumMujeres%>">
											<span class="select-bar"></span>
											<label for="EMP_NumMujeres" class="<%=lblClass%>">N° Mujeres</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(EMP_NumHombres<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="number" id="EMP_NumHombres" name="EMP_NumHombres" class="form-control" <%=disabled%> value="<%=EMP_NumHombres%>">
											<span class="select-bar"></span>
											<label for="EMP_NumHombres" class="<%=lblClass%>">N° Hombres</label>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-4">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="RUB_Id" id="RUB_Id" class="select-text form-control" <%=ds%>><%
													if((RUB_Id="") or (mode="add")) then%>
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
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Rubro</label>
											</div>
										</div>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="EMP_Id" name="EMP_Id" value="<%=EMP_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmempresas-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmempresas" name="btn_frmempresas"><%=typeFrm%></button>
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
		
		$("#btn_frmempresas").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Empresa agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Empresa modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmempresas");			
			if($("#frmempresas").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmempresas").attr("action"),
					data: $("#frmempresas").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmempresas")[0].reset();
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
	})
</script>