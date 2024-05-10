<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	PER_Id=request("PER_Id")	
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmperspectivas="frmperspectivas"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-perspectivas"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-perspectivas"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmperspectivas=""
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
		set rs = cnn.Execute("exec spPerspectiva_Consultar " & PER_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			PER_Id      = rs("PER_Id")
			PER_Nombre 	= rs("PER_Nombre")
			MOD_Id      = rs("MOD_Id")
			MOD_Nombre  = rs("MOD_Nombre")
			LIN_Id      = rs("LIN_Id")
			LIN_Nombre  = rs("LIN_Nombre")
			LIN_Estado  = rs("LIN_Estado")		
		end if		
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Perspectivas</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmperspectivas" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmperspectivas%>" id="<%=frmperspectivas%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select"><%
												if(mode="add") then%>
													<select name="LIN_Id" id="LIN_Id" class="select-text form-control" required><%
												else%>
													<select name="LIN_Id" id="LIN_Id" class="select-text form-control" disabled><%
												end if
													if((LIN_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec splinea_Listar -1, -1")
													on error resume next					
													do While Not rs.eof
														if(LIN_Id = rs("LIN_Id")) then%>
															<option value="<%=rs("LIN_Id")%>" selected><%=rs("LIN_Nombre")%></option><%
														else%>
															<option value="<%=rs("LIN_Id")%>"><%=rs("LIN_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span><%
												if(mode="add") then%>
													<label class="select-label">Línea</label><%
												else%>
													<label class="select-label active">Línea</label><%
												end if%>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="MOD_Id" id="MOD_Id" class="select-text form-control" <%=ds%>><%
													if((MOD_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spModuloLinea_Consultar " & LIN_Id)
													on error resume next					
													do While Not rs.eof
														if(MOD_Id = rs("MOD_Id")) then%>
															<option value="<%=rs("MOD_Id")%>" selected><%=rs("MOD_Nombre")%></option><%
														else%>
															<option value="<%=rs("MOD_Id")%>"><%=rs("MOD_Nombre")%></option><%
														end if
														rs.movenext						
													loop%>
												</select>
												<i class="fas fa-map-marker-alt input-prefix"></i>										
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Cursos</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-12">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(PER_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="PER_Nombre" name="PER_Nombre" class="form-control" <%=disabled%> value="<%=PER_Nombre%>">
											<span class="select-bar"></span>
											<label for="PER_Nombre" class="<%=lblClass%>">Perspectiva</label>
										</div>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="PER_Id" name="PER_Id" value="<%=PER_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmperspectivas-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmperspectivas" name="btn_frmperspectivas"><%=typeFrm%></button>
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
		
		function cursos(MOD_Id){
			var LIN_Id = $("#LIN_Id").val();			
			$.ajax({
				type: 'POST',
				url: '/seleccionar-cursos',
				data: {LIN_Id:LIN_Id,MOD_Id:MOD_Id},				
				success: function(data) {						
					$("#MOD_Id").html(data);
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){						
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				}
			})
		}
		
		
		$("#LIN_Id").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			cursos(null);
		})
		
		$("#btn_frmperspectivas").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Curso agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Curso modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmperspectivas");			
			if($("#frmperspectivas").valid()){				
				$.ajax({
					type: 'POST',
					url: $("#frmperspectivas").attr("action"),
					data: $("#frmperspectivas").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmperspectivas")[0].reset();
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