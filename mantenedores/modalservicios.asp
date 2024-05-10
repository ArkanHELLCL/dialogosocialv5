<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	SER_Id=request("SER_Id")
	GOB_Id=request("GOB_Id")
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then
		frmservicios="frmservicios"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-servicios"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-servicios"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmservicios=""
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
		set rs = cnn.Execute("exec spServicio_Consultar " & SER_Id & "," & GOB_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			SER_Id                  = rs("SER_Id")
			SER_Nombre              = rs("SER_Nombre")
			GOB_Id              	= rs("GOB_Id")
			GOB_NombreInstitucion   = rs("GOB_NombreInstitucion")			
		end if		
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Servicios</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmservicios" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmservicios%>" id="<%=frmservicios%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="GOB_Id" id="GOB_Id" class="select-text form-control" <%=ds%>><%												
													if((GOB_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spGobierno_Listar -1 ")
													on error resume next					
													do While Not rs.eof
														if(GOB_Id = rs("GOB_Id")) then%>
															<option value="<%=rs("GOB_Id")%>" selected><%=rs("GOB_NombreInstitucion")%></option><%
														else%>
															<option value="<%=rs("GOB_Id")%>"><%=rs("GOB_NombreInstitucion")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label">Ministerio</label>
											</div>
										</div>
									</div>
								</div>
																
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(SER_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="SER_Nombre" name="SER_Nombre" class="form-control" <%=disabled%> value="<%=SER_Nombre%>">
											<span class="select-bar"></span>
											<label for="SER_Nombre" class="<%=lblClass%>">Servicio</label>
										</div>
									</div>
								</div>								
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="SER_Id" name="SER_Id" value="<%=SER_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmservicios-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1 or session("ds5_usrperfil")=2) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmservicios" name="btn_frmservicios"><%=typeFrm%></button>
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
		
		$("#btn_frmservicios").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Servicio agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Servicio modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmservicios");			
			if($("#frmservicios").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmservicios").attr("action"),
					data: $("#frmservicios").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmservicios")[0].reset();
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