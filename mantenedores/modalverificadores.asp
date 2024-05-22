<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #INCLUDE file="session.min.inc" -->
<%	
	LFO_Id=request("LFO_Id")
	LIN_Id=request("LIN_Id")
	VER_Corr=request("VER_Corr")
	mode=request("mode")
	
	
	if(LFO_Id="") then
		LFO_Id=-1
	end if
	
	if (session("ds5_usrperfil")=1) then
		frmdocumentos="frmdocumentos"
		disabled="required"
		calendario="calendario"
		if(mode="add") then
			typeFrm="<i class='fas fa-plus ml-1'></i> Agregar"
			button="btn btn-success btn-md waves-effect"
			lblSelect=""
			action="/agregar-documentos"			
		else	
			if(mode="mod") then
				typeFrm="<i class='fas fa-download ml-1'></i> Grabar"
				button="btn btn-warning btn-md waves-effect"
				lblSelect=""
				action="/modificar-documentos"
			else
				typeFrm=""
				button=""
				action=""
				lblSelect=""
			end if
		end if
	else
		frmdocumentos=""
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
		set rs = cnn.Execute("exec spVerificador_Consultar " & LIN_Id & "," & VER_Corr)
		on error resume next	
		cnn.open session("DSN_DialogoSocialv5")
		if cnn.Errors.Count > 0 then 
		   ErrMsg = cnn.Errors(0).description	   
		   cnn.close
		   response.Write("503\\Error Conexión:" & ErrMsg)
		   response.End() 			   
		end if	
		if not rs.eof then			
			VER_Descripcion	= rs("VER_Descripcion")	
			VER_NumeroInforme = rs("VER_NumeroInforme")
			VER_Estado = rs("VER_EStado")
		end if		
		rs.Close		
	end if

	if(VER_Estado=1) then
		Estado="checked"
	else
		Estado=""		
	end if
	
	response.write("200\\")%>
	<div class="modal-dialog cascading-modal narrower modal-xl" role="document">  		
		<div class="modal-content">		
			<div class="modal-header view view-cascade gradient-card-header blue-gradient narrower py-2 mx-4 mb-3 d-flex justify-content-center align-items-center" style="height: 3rem;">
				<div class="text-left" style="font-size:1.25rem;"><i class="fas fa-server"></i> Documentos</div>				
			</div>				
			<div class="modal-body" style="padding:0px;">
				<div id="divfrmdocumentos" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
					<div class="px-4">						
						<form role="form" action="<%=action%>" method="POST" name="<%=frmdocumentos%>" id="<%=frmdocumentos%>" class="needs-validation">
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="LFO_Id" id="LFO_Id" class="select-text form-control" <%=ds%>><%
													if((LFO_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spLineaFormativa_Listar -1")
													on error resume next					
													do While Not rs.eof
														if(CInt(LFO_Id) = rs("LFO_Id")) then%>
															<option value="<%=rs("LFO_Id")%>" selected><%=rs("LFO_Nombre")%></option><%
														else%>
															<option value="<%=rs("LFO_Id")%>"><%=rs("LFO_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Línea Formativa</label>
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-12 col-lg-6">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select">
												<select name="LIN_Id" id="LIN_Id" class="select-text form-control" <%=ds%>><%
													if((LIN_Id="") or (mode="add")) then%>
														<option value="" disabled selected></option><%
													end if
													set rs = cnn.Execute("exec spLinea_Listar " & LFO_Id & ", -1")
													on error resume next					
													do While Not rs.eof
														if(CInt(LIN_Id) = rs("LIN_Id")) then%>
															<option value="<%=rs("LIN_Id")%>" selected><%=rs("LIN_Nombre")%></option><%
														else%>
															<option value="<%=rs("LIN_Id")%>"><%=rs("LIN_Nombre")%></option><%
														end if
														rs.movenext						
													loop
													rs.Close%>
												</select>
												<i class="fas fa-tag input-prefix"></i>											
												<span class="select-highlight"></span>
												<span class="select-bar"></span>
												<label class="select-label <%=lblSelect%>">Línea</label>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-3 col-lg-3">
									<div class="md-form input-with-post-icon">
										<div class="error-message">
											<div class="select" id="informes">												
											</div>
										</div>
									</div>
								</div>
								<div class="col-sm-12 col-md-9 col-lg-9">
									<div class="md-form input-with-post-icon">
										<div class="error-message">								
											<i class="fas fa-tag input-prefix"></i><%
											if(VER_Descripcion<>"") then
												lblClass="active"
											else
												lblClass=""
											end if%>
											<input type="text" id="VER_Descripcion" name="VER_Descripcion" class="form-control" <%=disabled%> value='<%=replace(VER_Descripcion,"\","")%>'>
											<span class="select-bar"></span>
											<label for="VER_Descripcion" class="<%=lblClass%>">Verificador</label>
										</div>
									</div>
								</div>																
							</div>
							<div class="row">
								<div class="col-sm-12 col-md-12 col-lg-2">
									<div class="switch">
										<input type="checkbox" id="VER_Estado" class="switch__input" <%=Estado%>>
										<label for="VER_Estado" class="switch__label">Activado</label>
									</div>
								</div>
							</div><%
							if(mode="mod") then%>
								<input type="hidden" id="VER_Corr" name="VER_Corr" value="<%=VER_Corr%>">
								<input type="hidden" id="VER_NumeroInformeX" name="VER_NumeroInformeX" value="<%=VER_NumeroInforme%>"
								<%
							end if%>						
						</form>
						<!--form-->
					</div>
					<!--px-4-->
				</div>
				<!--divfrmdocumentos-->												
			</div>
			<!--body-->
			<div class="modal-footer"><%
				if (session("ds5_usrperfil")=1) then%>
					<div style="float:left;" class="btn-group" role="group" aria-label="">
						<button class="<%=button%>" type="button" data-url="" title="Modificar Linea Formativa" id="btn_frmdocumentos" name="btn_frmdocumentos"><%=typeFrm%></button>
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
		
		function informes(){
			$.ajax({
				type: 'POST',
				url: "/listar-informes",
				data: {LFO_Id:$("#LFO_Id").val(), VER_NumeroInforme:$("#VER_NumeroInformeX").val()},				
				success: function(data) {
					var param=data.split(ss)
					if(param[0]=="200"){
						$("#informes").html(param[1])
					}else{
						console.log("listado de informes erroneo")
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){						
					console.log("no pude cargar el listado de informes " + XMLHttpRequest + " " + textStatus + " " + errorThrown)
				}
			})
		}
		informes();
		$("#LFO_Id").on("change",function(){
			informes();
		})
		
		$("#btn_frmdocumentos").click(function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var mode='<%=mode%>';			
			if(mode=="add"){
				var msg="Documento agregado exitosamente.";
			}else{
				if(mode=="mod"){
					var msg="Documento modificado exitosamente.";
				}else{
					var msg="Sin modo.";
				}				
			}
			formValidate("#frmdocumentos");			
			if($("#frmdocumentos").valid()){
				if($("#VER_Estado").is(":checked")){
					var VER_Estado = 1
				}else{
					var VER_Estado = 0
				}
				$.ajax({
					type: 'POST',
					url: $("#frmdocumentos").attr("action"),
					data: $("#frmdocumentos").serialize() + "&VER_Estado=" + VER_Estado,
					dataType: "json",
					success: function(data) {						
						if(data.state=="200"){
							if(mode=="add"){
								$("#frmdocumentos")[0].reset();
							}
							Toast.fire({
							  icon: 'success',
							  title: msg
							});
						}else{
							swalWithBootstrapButtons.fire({
								icon:'error',
								title:'Ingreso de Documento Fallido',
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
		
		$("#LFO_Id").on("change",function(e){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			var LFO_Id = $(this).val();
			
			$.ajax({
				type: 'POST',
				url: '/listar-linea',
				data: {LFO_Id:LFO_Id},
				success: function(data) {						
					$("#LIN_Id").html(data);
				},
				error: function(XMLHttpRequest, textStatus, errorThrown){						
					swalWithBootstrapButtons.fire({
						icon:'error',								
						title: 'Ups!, no pude cargar el menú del proyecto',					
					});				
				}
			})
			
		})
	})
</script>