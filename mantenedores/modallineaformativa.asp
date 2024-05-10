<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	LFO_Id=request("LFO_Id")
	mode=request("mode")
	
	if (session("ds5_usrperfil")=1) then
		frmlineaformativa="frmlineaformativa"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-lineaformativa"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect="active"
				action="/modificar-lineaformativa"
			else
				typeFrm=""
				button=""
				action=""
			end if
		end if
	else
		frmlineaformativa=""
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
		set rs = cnn.Execute("exec spLineaFormativa_Consultar " & LFO_Id)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then
			LFO_Nombre 	= rs("LFO_Nombre")
			LFO_Id		= rs("LFO_Id")
			LFO_Calif   = rs("LFO_Calif")
			FON_Nombre	= rs("FON_Nombres")
			FON_Id		= rs("FON_Id")
			LFO_PorcentajeMinEjecutado = rs("LFO_PorcentajeMinEjecutado")
			if(LFO_PorcentajeMinEjecutado="" or IsNULL(LFO_PorcentajeMinEjecutado)) then
				LFO_PorcentajeMinEjecutado = 0
			end if
		end if
		if LFO_CAlif=1 then
			checked = "checked"
		else
			checked = ""
		end if
		rs.Close		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Linea Formativa</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmlineaformativa" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmlineaformativa%>" id="<%=frmlineaformativa%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(LFO_Nombre<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="LFO_Nombre" name="LFO_Nombre" class="form-control" <%=disabled%> value="<%=LFO_Nombre%>" data-msg="Debes ingresar una descripción para la linea">
											<span class="select-bar"></span>
											<label for="LFO_Nombre" class="<%=lblClass%>">Línea Formativa</label>
										</div>
									</div>
								</div>							
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="FON_Id" id="FON_Id" class="select-text form-control" <%=ds%> data-msg="Debes seleccionar ítem presupuestario"><%
													if((FON_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spFondos_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(FON_Id = rs("FON_Id")) then%>
															<option value="<%=rs("FON_Id")%>" selected><%=rs("FON_Nombre")%></option><%
														else%>
															<option value="<%=rs("FON_Id")%>"><%=rs("FON_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-funnel-dollar input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Ítem Presupuestario</label>
											</div>
										</div>
									</div>
								</div>
							</div>							
							<div class="row" style="text-align: left;padding-bottom:20px;">
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<i class="fas fa-percent input-prefix"></i>											
											<input type="text" id="LFO_PorcentajeMinEjecutado" name="LFO_PorcentajeMinEjecutado" class="form-control" value="<%=LFO_PorcentajeMinEjecutado%>" <%=disabled%> min="1" max="100" required data-msg="Debes ingresar un porcentaje válido">
											<span class="select-bar"></span><%
											if(mode="add") then%>
												<label for="LFO_PorcentajeMinEjecutado">Porcentaje mínimo planificación ejecutada (Parcial)</label><%
											else%>
												<label for="LFO_PorcentajeMinEjecutado" class="active">Porcentaje mínimo planificación ejecutada (Parcial)</label><%
											end if%>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-6 col-lg-6">
									<div class="rkmd-checkbox checkbox-rotate checkbox-ripple" style="display: contents;">
										<label class="input-checkbox checkbox-lightBlue">
											<input type="checkbox" id="LFO_Calif" name="LFO_Calif" class="toggle" <%=checked%><%=" "%><%=ds%>>
											<span class="checkbox"></span>											
										</label>
										<label for="LFO_Calif" class="label">¿Incluir Calificaciones?</label>
									</div>									
								</div>								
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="LFO_Id" name="LFO_Id" value="<%=LFO_Id%>"><%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmlineaformativa-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmlineaformativa" name="btn_frmlineaformativa"><%=typeFrm%></button>
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
		$("#btn_frmlineaformativa").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';
			
			if(mode=="add"){
				var msg="Linea formativa agregada exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Linea formativa modificada exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmlineaformativa");			
			if($("#frmlineaformativa").valid()){
				$.ajax({
					type: 'POST',
					url: $("#frmlineaformativa").attr("action"),
					data: $("#frmlineaformativa").serialize(),
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmlineaformativa")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de linea formativa Fallido',
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